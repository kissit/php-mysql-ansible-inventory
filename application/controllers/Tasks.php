<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Tasks extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
        if(!$this->config->item('tasks_on', 'custom')) {
            redirect("/");
        }
        $this->load->model('batch_model');
    }

    // Display the main page/login screen
    public function index() {
        $data = array('page_title' => 'Ansible Tasks');
        $data['rows'] = $this->batch_model->getRows();
        $this->templateDisplay('tasks/index.tpl', $data);
    }

    // Display the submit task page/form
    public function submit() {
        $data = array('page_title' => 'Submit Ansible Task');
        $this->templateDisplay('tasks/submit.tpl', $data);
    }

    // Handle the submit of the task page/form
    public function doSubmit() {
        $post = array();
        if(!empty($this->input->post('raw_command'))) {
            $post['command'] = $this->input->post('raw_command');
        } else {
            $post = (array)$this->input->post('post');
        }
        $post['status'] = 'queued';
        $post['created_by'] = $this->getUserId();
        
        $id = $this->batch_model->setRow(0, $post);
        if($id > 0) {
            $this->setMessage("Task submitted and will be started on the next minute");
            //redirect("/tasks/view/$id");
            redirect("/tasks");
        } else {
            $this->setMessage();
            redirect("/tasks");
        }
        
    }
}