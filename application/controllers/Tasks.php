<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Tasks extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
        if(!$this->config->item('tasks_on', 'custom')) {
            redirect("/");
        }
        $this->load->model('tasks_model');
    }

    // Display the main page/login screen
    public function index() {
        $this->load->helper('text');
        $data = array('page_title' => 'Ansible Tasks', 'rows' => array());
        $rows = $this->tasks_model->getRows();
        foreach($rows as $row) {
            $row['notes'] = character_limiter($row['notes'], 30, "...");
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
        $task = $this->tasks_model->getRow($id);
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
        $task = $this->tasks_model->getRow($id);
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
            $check = $this->tasks_model->getRow($id);
            if(!empty($check) && $check['status'] == 'queued') {
                $this->tasks_model->setRow($id, array('status' => 'cancelled'));
                $this->setMessage("Task cancelled");
            } else {
                $this->setMessage("Task is no longer queued, cannot cancel", "danger");
            }
        } else {
            $this->setMessage();
        }
        redirect("/tasks");
    }

    // Display the submit task page/form
    public function submit() {
        $data = array('page_title' => 'Submit Ansible Task');
        $preconfigured_tasks = $this->tasks_model->getRows(array(), 'tasks_preconfigured');
        foreach($preconfigured_tasks as $key => $row) {
            $preconfigured_tasks[$key]['name'] = "{$row['name']} ({$row['command']})";
        }
        $data['preconfigured_tasks_options'] = $this->getOptions($preconfigured_tasks);
        $this->templateDisplay('tasks/submit.tpl', $data);
    }

    // Handle the submit of the task page/form
    public function doSubmit() {
        $post = array();
        $preconfigured_task = (int)$this->input->post('preconfigured_task');
        if($preconfigured_task > 0) {
            // First handle a selected preconfigured task
            $task = $this->tasks_model->getRow($preconfigured_task, 'tasks_preconfigured');
            if(empty($task)) {
                $this->setMessage();
                redirect("/tasks/submit");
            } else {
                $post['command'] = $task['command'];
                $post['command_limit'] = (string)$this->input->post('preconfigured_task_limit');
                $post['notes'] = "Submitted from preconfigured task {$task['name']} ($preconfigured_task)";
            }
        } elseif(!empty($this->input->post('raw_command'))) {
            // If no preconfigured task take a raw command if present
            $post['command'] = $this->input->post('raw_command');
        } else {
            // If nothing else take the piece by piece form
            $post = (array)$this->input->post('post');
        }
        $post['status'] = 'queued';
        $post['created_by'] = $this->getUserId();
        
        $id = $this->tasks_model->setRow(0, $post);
        if($id > 0) {
            $this->setMessage("Task queued");
        } else {
            $this->setMessage();
        }
        redirect("/tasks");
    }

    // Handle re-running an existing task
    public function reRun($id) {
        $check = $this->tasks_model->getRow($id);
        if(!empty($check)) {
            $redo = array(
                'status' => 'queued',
                'command' => $check['command'],
                'notes' => "Rerun of task id {$check['id']}",
                'created_by' => $this->getUserId()
            );
            $id = $this->tasks_model->setRow(0, $redo);
            if($id > 0) {
                $this->setMessage("Task queued");
                redirect("/tasks");
            } else {
                $this->setMessage();
                redirect("/tasks");
            }
        }
    }

    // Show the page to view and manage preconfigured tasks
    public function preconfiguredTasks() {
        $this->load->helper('text');
        $data = array('page_title' => 'Manage Preconfigured Tasks');
        $rows = $this->tasks_model->getRows(array(), 'tasks_preconfigured');
        foreach($rows as $row) {
            $row['description'] = character_limiter($row['description'], 50, "...");
            if($row['created_by'] > 0) {
                $row['owner'] = $this->ion_auth->user($row['created_by'])->row_array();
            }
            $data['rows'][] = $row;
        }
        $this->templateDisplay('tasks/preconfigured_tasks.tpl', $data);
    }

    // Show the edit preconfigured task form
    public function editPreconfiguredTask($id = 0) {
        $data = array();
        $id = (int)$id;

        // Lookup the task if specified
        if($id > 0) {
            $data['row'] = $this->tasks_model->getRow($id, 'tasks_preconfigured');
        }
        
        if(!empty($data['row'])) {
            $data['page_title'] = 'Edit Preconfigured Task';
        } else {
            $data['page_title'] = 'Add Preconfigured Task';
        }
        $this->templateDisplay('tasks/edit_preconfigured_task.tpl', $data);
    }

    // Handle the submit of the task page/form
    public function setPreconfiguredTask() {
        $id = (int)$this->input->post('id');
        $post = (array)$this->input->post('post');
        if($id <= 0) {
            $post['created_by'] = $this->getUserId();
        }
        $id = $this->tasks_model->setRow($id, $post, 'tasks_preconfigured');
        if($id > 0) {
            $this->setMessage("Preconfigured task updated");
        } else {
            $this->setMessage();
        }
        redirect("/tasks/preconfiguredTasks");
    }

    // Handle deleting a preconfigured task
    public function deletePreconfiguredTask($id) {
        if($this->tasks_model->deleteRow($id, 'tasks_preconfigured')) {
            echo "1";
        } else {
            echo "0";
        }
    }
}