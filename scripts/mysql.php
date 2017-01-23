#!/usr/bin/env php
<?php
$db_host = "localhost";
$db_user = "devuser";
$db_pass = "devuser";
$db_name = "ansible";

$inventory = array();
$servers = array();
$meta = array();
$output_inventory = true;
$nagios_groups = array();

// Configure our CLI options and use getopt to parse
$shortopts = "";
$longopts = array("help", "list", "reset", "host::", "groups::", "nagios::");
$opts = getopt($shortopts, $longopts);

// Show the help message if desired
if(isset($opts['help'])) {
    print_help();
}

// Connect to the DB
$db = new mysqli($db_host, $db_user, $db_pass, $db_name);
if($db->connect_error) {
    exit("Failed connecting to database: {$db->connect_error} ({$db->connect_errno})");
}

// Do stuff based on our options
if(isset($opts['list'])) {
    // We are --list ing Get all active servers
    $result = $db->query("SELECT * FROM servers WHERE status = '1'");
    if($result === false) {
        exit("Query error: {$db->error} ({$db->errno})");
    } else {

        // Lookup our nagios hostgroups and build an array by servers_id
        $nagios = $db->query("SELECT s.id, g.name AS group_name FROM servers AS s INNER JOIN servers_nagios_groups AS sg ON s.id = sg.servers_id INNER JOIN nagios_groups AS g ON sg.nagios_groups_id = g.id WHERE s.status = '1'");
        if($nagios !== false) {
            while($temp = $nagios->fetch_assoc()) {
                $nagios_groups[$temp['id']][] = $temp['group_name'];
            }
        }

        // Now process our servers into the meta array
        while($row = $result->fetch_assoc()) {
            // Include our nagios hostgroups in a comma separated list to be shoved into nagios cfg files
            if(isset($nagios_groups[$row['id']])) {
                $row['nagios_hostgroups'] = implode(",", $nagios_groups[$row['id']]);
            }

            // Set our ansible IP to use for each server and add that to the meta array
            $row['ansible_ssh_host'] = $row['public_ip'];
            $servers[$row['id']] = $row;
            $meta[$row['server_name']] = $row;

            // Everything gets added to the common role
            $inventory['common'][] = $row['server_name'];

            // And also build out groups for region
            if(!empty($row['region'])) {
                $inventory[$row['region']][] = $row['server_name'];
            }

            // And also build out groups for the app
            if(!empty($row['app'])) {
                $inventory["app_{$row['app']}"][] = $row['server_name'];
            }
        }
    }

    // Get our inventory mapping
    $result = $db->query("SELECT s.server_name, g.name AS group_name FROM servers AS s INNER JOIN servers_groups AS sg ON s.id = sg.servers_id INNER JOIN groups AS g ON sg.groups_id = g.id WHERE status = '1'");
    while($row = $result->fetch_assoc()) {
        $inventory[$row['group_name']][] = $row['server_name'];
    }

    // Then add in our meta data
    $inventory['_meta']['hostvars'] = $meta;
} elseif(isset($opts['host']) && !empty($opts['host'])) {
    // If we are asking for details of a specific host, just do that
    $host = $db->real_escape_string($opts['host']);
    $result = $db->query("SELECT * FROM servers WHERE server_name = '$host' AND status = '1'");
    if($result === false) {
        exit("Query error: {$db->error} ({$db->errno})");
    } else {
        // Fetch our matching host if we have one
        $inventory = $result->fetch_assoc();
        if(!empty($inventory)) {
            $inventory['ansible_ssh_host'] = $inventory['public_ip'];

            if(isset($opts['groups'])) {
                // We are making a call to set the groups for a host, not return inventory
                $groups = explode(",", $opts['groups']);

                // If we are resetting groups, do that first
                if(isset($opts['reset'])) {
                    $db->query("DELETE FROM servers_groups WHERE servers_id = '{$inventory['id']}'");
                }

                // now process the passed in groups
                foreach($groups as $group) {
                    if(!empty($group)) {
                        $group = $db->real_escape_string($group);
                        if($check = $db->query("SELECT id FROM groups WHERE name = '$group'")) {
                            $temp = $check->fetch_assoc();
                            if(empty($temp)) {
                                $db->query("INSERT INTO groups(name) VALUES('$group')");
                                $groups_id = $db->insert_id;
                            } else {
                                $groups_id = $temp['id'];
                            }
                            $db->query("INSERT IGNORE INTO servers_groups(servers_id, groups_id) VALUES('{$inventory['id']}', '{$groups_id}')");
                        }
                    }
                }

                // And output the groups when done
                $temp = array();
                $result = $db->query("SELECT g.name FROM servers_groups AS sg INNER JOIN groups AS g ON sg.groups_id = g.id WHERE sg.servers_id = '{$inventory['id']}' ORDER BY g.name ASC");
                if($result !== false) {
                    while($row = $result->fetch_assoc()) {
                        $temp[] = $row['name'];
                    }
                }
                echo "Groups: " . implode(",", $temp) . "\n";

                $output_inventory = false;
            }
            if(isset($opts['nagios'])) {
                // We are making a call to set the nagios groups for a host, not return inventory
                $groups = explode(",", $opts['nagios']);
                
                // If we are resetting groups, do that first
                if(isset($opts['reset'])) {
                    $db->query("DELETE FROM servers_nagios_groups WHERE servers_id = '{$inventory['id']}'");
                }

                // now process the passed in groups
                foreach($groups as $group) {
                    if(!empty($group)) {
                        $group = $db->real_escape_string($group);
                        if($check = $db->query("SELECT id FROM nagios_groups WHERE name = '$group'")) {
                            $temp = $check->fetch_assoc();
                            if(empty($temp)) {
                                $db->query("INSERT INTO nagios_groups(name) VALUES('$group')");
                                $groups_id = $db->insert_id;
                            } else {
                                $groups_id = $temp['id'];
                            }
                            $db->query("INSERT IGNORE INTO servers_nagios_groups(servers_id, nagios_groups_id) VALUES('{$inventory['id']}', '{$groups_id}')");
                        }
                    }
                }

                // And output the groups when done
                $temp = array();
                $result = $db->query("SELECT g.name FROM servers_nagios_groups AS sg INNER JOIN nagios_groups AS g ON sg.nagios_groups_id = g.id WHERE sg.servers_id = '{$inventory['id']}' ORDER BY g.name ASC");
                if($result !== false) {
                    while($row = $result->fetch_assoc()) {
                        $temp[] = $row['name'];
                    }
                }
                echo "Nagios Hostgroups: " . implode(",", $temp) . "\n";

                $output_inventory = false;
            }

            if($output_inventory) {
                // Include our nagios hostgroups in a comma separated list to be shoved into nagios cfg files
                $nagios = $db->query("SELECT g.name AS group_name FROM servers_nagios_groups AS sg INNER JOIN nagios_groups AS g ON sg.nagios_groups_id = g.id WHERE sg.servers_id = '{$inventory['id']}'");
                if($nagios !== false) {
                    $nagios_groups = array();
                    while($temp = $nagios->fetch_assoc()) {
                        $nagios_groups[] = $temp['group_name'];
                    }
                    if(!empty($nagios_groups)) {
                        $inventory['nagios_hostgroups'] = implode(",", $nagios_groups);
                    }
                }
            }
        } else {
            $output_inventory = false;
            echo "Host not found\n";
        }
    }
} else {
    print_help();
}

// And we're done
if($output_inventory) {
    echo json_encode($inventory, JSON_PRETTY_PRINT) . "\n";
}
exit(0);

/////////////////////////////////////////////////////////////////////////////////////////////
// Function to print the help message with options
function print_help($error = '') {
$help = <<<EOD
mysql.php - Inventory script for Ansible to use a MySQL database as the source
The following options are available:
    --help:  Print this help
    --list:  List all available inventory
    --host:  Get the specific details for a given host
    --groups: A comma separated list of group(s) to add to the specified host.
    --nagios: A comma separated list of nagios hostgroup(s) that the host belongs to.
    --reset: If passed all groups & nagios groups for the specified host will be reset to what is passed.

EOD;

    echo $help;
    exit(0);
}
