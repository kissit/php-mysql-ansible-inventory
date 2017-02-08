<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Servers extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
        $this->load->model('servers_model');
        $this->load->model('groups_model');
        $this->load->model('monitor_groups_model');
    }

    // Main server list page
    public function index() {
        $data = array('page_title' => 'Servers List');
        $data['rows'] = $this->servers_model->getRows();
        $this->templateDisplay('servers/index.tpl', $data);
    }

    // Display the add/edit server page
    public function edit($id = 0) {
        $data = array();
        $id = (int)$id;
        $selected_monitor_groups = $selected_groups = array();

        // Lookup the server if specified
        if($id > 0) {
            $data['row'] = $this->servers_model->getRow($id);
            if(!empty($data['row'])) {
                $selected_groups = $this->groups_model->getGroupsByServer($id);
                $selected_monitor_groups = $this->monitor_groups_model->getGroupsByServer($id);
            }
        }

        // Get the options for the groups selects
        $data['groups_options'] = $this->getOptions($this->groups_model->getRows(array(), null, "name ASC"), $this->getLookups($selected_groups, 'id'));
        $data['monitor_groups_options'] = $this->getOptions($this->monitor_groups_model->getRows(array(), null, "name ASC"), $this->getLookups($selected_monitor_groups, 'id'));
        
        if(!empty($data['row'])) {
            $data['page_title'] = 'Edit Server';
        } else {
            $data['page_title'] = 'Add Server';
        }
        $this->templateDisplay('servers/edit.tpl', $data);
    }

    // Handle updating a server
    public function update() {
        $id = (int)$this->input->post('id');
        $post = (array)$this->input->post('post');
        $groups = (array)$this->input->post('groups');
        $monitor_groups = (array)$this->input->post('monitor_groups');

        $id = $this->servers_model->setRow($id, $post);
        if($id > 0) {
            $this->groups_model->setGroupsByServer($id, $groups);
            $this->monitor_groups_model->setGroupsByServer($id, $monitor_groups);
            $this->setMessage("Server saved");
            if($this->input->post('save_add') === null) {
                redirect("/servers");
            } else {
                redirect("/servers/edit");
            }
        } else {
            $this->setMessage();
            redirect("/servers");
        }
    }

    // Handle a change of status call (Ajax)
    public function setStatus($id, $status) {
        echo $this->servers_model->setRow($id, array('status' => $status));
    }

    // Handle deleting a server
    public function delete($id) {
        $this->groups_model->deleteWhere(array('servers_id' => $id), 'servers_groups');
        $this->monitor_groups_model->deleteWhere(array('servers_id' => $id), 'servers_monitor_groups');
        if($this->servers_model->deleteRow($id)) {
            echo "1";
        } else {
            echo "0";
        }
    }
}
