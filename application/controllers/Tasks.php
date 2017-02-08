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
        $data = array('page_title' => 'Ansible Tasks', 'rows' => array());
        $rows = $this->batch_model->getRows();
        foreach($rows as $row) {
            if($row['created_by'] > 0) {
                $row['owner'] = $this->ion_auth->user($row['created_by'])->row_array();
            }
            $data['rows'][] = $row;
        }
        $this->templateDisplay('tasks/index.tpl', $data);
    }

    // Display the view task details screen
    public function view($id) {
        $data = array('page_title' => 'Task Details');
        $task = $this->batch_model->getRow($id);
        if(!empty($task)) {
            $task['owner'] = $this->ion_auth->user($task['created_by'])->row_array();

            if(!empty($task['output_file']) && file_exists($task['output_file'])) {
                $data['log_data'] = file_get_contents($task['output_file']);
                if($data['log_data'] === false) {
                    $data['log_data'] = "Unable to read log file";
                }
            }

            $data['task'] = $task;
            $this->templateDisplay('tasks/view.tpl', $data);
        } else {
            $this->setMessage();
            redirect("/tasks");
        }       
    }

    // Retrieve updated data about the task
    public function check($id) {
        $return = array();
        $task = $this->batch_model->getRow($id);
        if(!empty($task)) {
            $return['task'] = $task;
            if(!empty($task['output_file']) && file_exists($task['output_file'])) {
                $return['log_data'] = file_get_contents($task['output_file']);
                if($return['log_data'] === false) {
                    $return['log_data'] = "Unable to read log file";
                }
            } else {
                 $return['log_data'] = "Log file not found";
            }
        }
        $this->returnJson($return);
    }

    // Function to cancel a task that is in status == queue.  Otherwise do nothing.
    public function cancel($id) {
        $id = (int)$id;
        if($id > 0) {
            $check = $this->batch_model->getRow($id);
            if(!empty($check) && $check['status'] == 'queued') {
                $this->batch_model->setRow($id, array('status' => 'cancelled'));
                $this->setMessage("Task cancelled");
            } else {
                $this->setMessage("Task is no longer queued, cannot cancel", "danger");
            }
            redirect("/tasks/view/$id");
        } else {
            $this->setMessage();
            redirect("/tasks");
        }
    }

    // Display the submit task page/form
    public function submit() {
        $data = array('page_title' => 'Submit Ansible Task');
        $this->templateDisplay('tasks/submit.tpl', $data);
    }

    // Handle the submit of the task page/form
    public function doSubmit() {
        $post = (array)$this->input->post('post');
        $message = '';
        if(!empty($this->input->post('raw_command'))) {
            $post['command'] = $this->input->post('raw_command');
        }
        $post['status'] = 'queued';
        $post['created_by'] = $this->getUserId();
        
        $id = $this->batch_model->setRow(0, $post);
        if($id > 0) {
            $this->setMessage("Task queued");
            redirect("/tasks");
        } else {
            $this->setMessage();
            redirect("/tasks");
        }
        
    }
}