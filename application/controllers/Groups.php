<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Groups extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
        $this->load->model('groups_model');
        $this->load->model('monitor_groups_model');
    }

    // Main server list page
    public function index() {
        $data = array('page_title' => 'Manage Groups');
        $data['groups_rows'] = $this->groups_model->getRows();
        $data['monitor_groups_rows'] = $this->monitor_groups_model->getRows();
        $data['servers_groups'] = $this->getLookups($this->groups_model->getCounts(), 'servers_count');
        $data['servers_monitor_groups'] = $this->getLookups($this->monitor_groups_model->getCounts(), 'servers_count');
        $this->templateDisplay('groups/index.tpl', $data);
    }

    // Display the add/edit server page
    public function getGroupForm($id, $group_type) {
        $this->load->model('servers_model');
        $data = array('group_type' => $group_type);
        $id = (int)$id;
        $selected = array();

        // Lookup our details based on what is passed in
        if($group_type == 'groups') {
            if($id > 0) {
                $data['group'] = $this->groups_model->getRow($id);
                $selected = $this->groups_model->getServersByGroup($id);
            }
        } elseif($group_type == 'monitor_groups') {
            if($id > 0) {
                $data['group'] = $this->monitor_groups_model->getRow($id);
                $selected = $this->monitor_groups_model->getServersByGroup($id);
            }
        }

        // Get the options for the servers select
        $data['servers_options'] = $this->getOptions($this->servers_model->getRows(array(), null, "server_name ASC"), $this->getLookups($selected, 'id'), 'server_name');        
        
        echo $this->templateRender('groups/group_form.tpl', $data);
    }

    // Handle updating a group (Ajax)
    public function update() {
        //{type: "groupSaved", id: id, edit_id: edit_id, name: name, group_type: type}
        $id = (int)$this->input->post('id');
        $name = str_replace(' ', '_', $this->input->post('name'));
        $group_type = $this->input->post('group_type');
        $group_servers = (array)$this->input->post('group_servers');
        $return = array('type' => 'groupSaved', 'id' => 0, 'name' => $name, 'group_type' => $group_type, 'count' => 0);
        if($group_type == 'groups') {
            $return['id'] = $this->groups_model->setRow($id, array('name' => $name));
            if($return['id'] > 0) {
                $return['count'] = $this->groups_model->setServersByGroup($return['id'], $group_servers, true);
            }
        } elseif($group_type == 'monitor_groups') {
            $return['id'] = $this->monitor_groups_model->setRow($id, array('name' => $name));
            if($return['id'] > 0) {
                $return['count'] = $this->monitor_groups_model->setServersByGroup($return['id'], $group_servers, true);
            }
        }
        $this->returnJson($return);
    }

    // Handle a change of status call (Ajax)
    public function delete($type, $id) {
        $return = 0;
        if($type == 'groups') {
            $this->groups_model->deleteWhere(array('groups_id' => $id), 'servers_groups');
            $return = $this->groups_model->deleteRow($id);
        } elseif ($type == 'monitor_groups') {
            $this->monitor_groups_model->deleteWhere(array('monitor_groups_id' => $id), 'servers_monitor_groups');
            $return = $this->monitor_groups_model->deleteRow($id);
        }
        echo "$return";
    }
}
