<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Groups_model extends MY_Model {

    public function __construct() {
        parent::__construct();
        $this->set('table', 'groups');
    }

    // Function to get an array of group ids for a specific server id
    public function getGroupsByServer($server_id) {
        return $this->db->select("groups_id AS id")->from('servers_groups')->where('servers_id', $server_id)->get()->result_array();
    }

    // Function to set the groups for a specific server
    public function setGroupsByServer($server_id, $groups) {
        $this->setLookups('servers_id', $server_id, 'groups_id', $groups, 'servers_groups');
    }

    // Function to get the selected servers by group
    public function getServersByGroup($id) {
        return $this->db->select("g.servers_id AS id")->from('servers_groups AS g')->where('g.groups_id', $id)->get()->result_array();
    }

    // Function to set the selected servers by group
    public function setServersByGroup($id, $servers, $clear = false) {
        $servers = (array)$servers;
        $count = count($servers);
        if($clear) {
            $this->deleteWhere(array('groups_id' => $id), 'servers_groups');
        }
        foreach($servers as $server) {
            $this->db->insert('servers_groups', array('servers_id' => $server, 'groups_id' => $id));
        }
        return $count;
    }

    // Function to get a count of servers for each group
    public function getCounts() {
        return $this->db->select("groups_id AS id, count(servers_id) AS servers_count")->from("servers_groups")->group_by("groups_id")->get()->result_array();
    }
}
