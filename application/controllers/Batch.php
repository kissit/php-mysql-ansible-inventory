<?php
defined('BASEPATH') OR exit('No direct script access allowed');
/*
 * Controller used for running batch processes from the command line.  For instance, calling it as follows:
 * 
 * php public/index.php batch processAnsibleQueue
 */
class Batch extends CI_Controller {
    
    private $cmd_log = '';

    public function __construct() {
        parent::__construct();
        $this->load->model('batch_model');
        $this->load->library('messages');
        $this->load->library('locking');

        // Only allow running from cli
        if(!is_cli()) {
            exit('Only available from cli...');
        }

        $this->tasks_log_path = $this->config->item('tasks_log_path', 'custom');
    }

    private function log($str, $summary = true) {
        if($this->logging) {
            $msg = date('Y-m-d H:i:s') . " -> $str\n";
            echo $msg;
        }
    }

    private setCmdLog($filename) {
        $this->cmd_log = $this->config->item('tasks_log_path', 'custom') . "/" . $filename;
    }

    private writeCmdLog($log) {
        if($this->cmd_log) {
            $log = date("Y-m-d H:i:s") . " --> $log\n";
            file_put_contents($this->cmd_log, $log, FILE_APPEND);
        }
    }

    // Function to check for queued ansible jobs to be run.  If found run them yea?
    /* ansible-playbook exit statuses, though there seems to be some difference of opinion
     * https://groups.google.com/forum/#!msg/ansible-project/TZUToE_vYdA/rOtHMGSLKQAJ
     * https://github.com/ansible/ansible/issues/19720

       0 -- OK or no hosts matched
       1 -- Error
       2 -- One or more hosts failed
       3 -- One or more hosts were unreachable
       4 -- Parser error
       5 -- Bad or incomplete options
       99 -- User interrupted execution
       250 -- Unexpected error
    */
    public function processAnsibleQueue() {
        $this->locking->init('processAnsibleQueue');
        if($this->locking->setLock()) {
            // Check for queue'd requests
            $queue = $this->batch_model->getRows(array('status' => 'queued'));
            foreach($queue as $task) {
                $id = $task['id'];
                $task_start = time();

                // Set our current tasks output log and start it
                $this->setCmdLog($id . "_" . date("Ymd_His", $task_start) . ".log";
                $this->writeCmdLog("Starting to process task id {$task['id']}");

                // Update our state in the DB
                $this->batch_model->setRow($id, array('status' => 'running', 'output_file' => $this->cmd_log, 'start_date' => date("Y-m-d H:i:s", $task_start)));
                
                // Build the command (or use a raw one if passed)
                $cmd = null;
                if(!empty($task['command'])) {
                    if(strpos($task['command'], 'ansible')) === 0) {
                        $cmd = $task['command'];
                    }
                } else {
                    if(!empty($task['command_name'])) {
                        $cmd = $task['command_name'];
                        $cmd .= " {$task['command_name']}";
                        $cmd .= (!empty($task['command_limit'])) ? " --limit={$task['command_limit']}" : "";
                        $cmd .= (!empty($task['command_tags'])) ? " --tags={$task['command_tags']}" : "";
                    }
                }

                // Run the command if we have one
                if($cmd) {
                    $cmd = escapeshellcmd($cmd);
                    $return_code = 0;
                    $status = system($cmd, $return_code);
                    if($status !== false) {
                        // system command completed
                    } else {
                        // system command failed
                    }
                } else {
                    // Empty command detected
                }
                

            }

            $this->locking->clearLock();
        } else {
            $this->log("Failed to set lock file...another process may still be running or failed");
        }
    }
}
