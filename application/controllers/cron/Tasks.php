<?php
defined('BASEPATH') OR exit('No direct script access allowed');
/*
 * Controller used for running batch processes from the command line.  For instance, calling it as follows:
 * 
 * php public/index.php cron/tasks processAnsibleQueue
 */
class Tasks extends CI_Controller {
    
    private $cmd_log = '';

    public function __construct() {
        parent::__construct();
        $this->load->model('tasks_model');
        $this->load->library('messages');
        $this->load->library('locking');
        $this->config->load('custom', TRUE);

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

    private function setCmdLog($filename) {
        $path = $this->config->item('tasks_log_path', 'custom');
        if(is_writable($path)) {
            $this->cmd_log = "{$path}/{$filename}";
            return $this->cmd_log;
        } else {
            return false;
        }
    }

    private function writeCmdLog($log) {
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

            // Check for queue'd requests if we can change to the ansible project directory
            $ansible_dir = $this->config->item('ansible_project_path', 'custom');
            if(chdir($ansible_dir)) {    
                $queue = $this->tasks_model->getRows(array('status' => 'queued'));
            } else {
                $queue = array();
                echo date("Y-m-d H:i:s") . " -> ERROR: Cannot change to ansible directory: $ansible_dir\n";
            }

            foreach($queue as $task) {
                $id = $task['id'];
                $task_start = time();

                // Set our current tasks output log and start it
                if($this->setCmdLog($id . "_" . date("Ymd_His", $task_start) . ".log")) {
                    $this->writeCmdLog("Starting to process task id {$id}");

                    // Update our state in the DB
                    $this->tasks_model->setRow($id, array('status' => 'running', 'output_file' => $this->cmd_log, 'start_date' => date("Y-m-d H:i:s", $task_start)));
                    
                    // Build the command (or use a raw one if passed)
                    $cmd = null;
                    if(!empty($task['command'])) {
                        if(strpos($task['command'], 'ansible') === 0) {
                            $cmd = $task['command'];
                        }
                    } else {
                        if(!empty($task['command_name']) && !empty($task['playbook'])) {
                            $cmd = "{$task['command_name']} {$task['playbook']}";
                            $cmd .= (!empty($task['command_limit'])) ? " --limit={$task['command_limit']}" : "";
                            $cmd .= (!empty($task['command_tags'])) ? " --tags={$task['command_tags']}" : "";
                            $cmd .= (!empty($task['command_options'])) ? " {$task['command_options']}" : "";

                            // Update our cmd in the DB
                            $this->writeCmdLog("COMMAND BUILT AS: $cmd");
                            $this->tasks_model->setRow($id, array('command' => $cmd));
                        } else {
                            $this->writeCmdLog("ERROR: unable to build command");
                        }
                    }

                    // Run the command if we have one
                    if($cmd) {
                        // Escape just in case someone tries to input something bad.  Won't stop all things of course
                        $cmd = escapeshellcmd($cmd);
                        
                        // Redirect STDOUT & STDERR to our log file
                        $cmd = "{$cmd} >> {$this->cmd_log}";

                        // Run the command
                        $task_status = 'error';
                        $return_code = 0;
                        $status = system($cmd, $return_code);
                        if($status !== false && $return_code === 0) {
                            // system command completed
                            $log = "COMPLETE: Command completed for task id {$id}";
                            $task_status = 'complete';
                        } else {
                            // system command failed
                            $log = "ERROR: Command failed for task id {$id}.  Return code: $return_code";
                        }
                    } else {
                        // Empty command detected
                        $log = "ERROR: Empty command for task id {$id}";
                    }

                    $this->writeCmdLog($log);
                    $this->tasks_model->setRow($id, array('status' => $task_status, 'end_date' => date("Y-m-d H:i:s")));
                } else {
                    $this->writeCmdLog("ERROR: Log directory is not writeable for task id {$id}");
                    $this->tasks_model->setRow($id, array('status' => 'error', 'end_date' => date("Y-m-d H:i:s")));
                }
            }
            $this->locking->clearLock();
        } else {
            $this->log("Failed to set lock file...another process may still be running or failed");
        }
    }
}
