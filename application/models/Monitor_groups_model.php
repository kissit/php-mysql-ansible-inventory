<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Monitor_groups_model extends MY_Model {

    public function __construct() {
        parent::__construct();
        $this->set('table', 'monitor_groups');
    }

    // Function to get an array of group ids for a specific server id
    public function getGroupsByServer($server_id) {
        return $this->db->select("monitor_groups_id AS id")->from('servers_monitor_groups')->where('servers_id', $server_id)->get()->result_array();
    }

    // Function to set the groups for a specific server
    public function setGroupsByServer($server_id, $groups) {
        $this->setLookups('servers_id', $server_id, 'monitor_groups_id', $groups, 'servers_monitor_groups');
    }
    
    // Function to get the selected servers by group
    public function getServersByGroup($id) {
        return $this->db->select("servers_id AS id")->from('servers_monitor_groups')->where('monitor_groups_id', $id)->get()->result_array();
    }

    // Function to set the selected servers by group
    public function setServersByGroup($id, $servers, $clear = false) {
        $servers = (array)$servers;
        $count = count($servers);
        if($clear) {
            $this->deleteWhere(array('monitor_groups_id' => $id), 'servers_monitor_groups');
        }
        foreach($servers as $server) {
            $this->db->insert('servers_monitor_groups', array('servers_id' => $server, 'monitor_groups_id' => $id));
            //$this->debugLastQuery();
        }
        return $count;
    }

    // Function to get a count of servers for each group
    public function getCounts() {
        return $this->db->select("monitor_groups_id AS id, count(servers_id) AS servers_count")->from("servers_monitor_groups")->group_by("monitor_groups_id")->get()->result_array();
    }
}