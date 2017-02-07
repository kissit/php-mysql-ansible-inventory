<?php defined('BASEPATH') OR exit('No direct script access allowed');

// These are options for passing in $stale_lock_action for handling of stale lock files
define('LOCK_CLEAR_STALE_NO', 0);
define('LOCK_CLEAR_STALE_YES', 1);
// These are used for statuses of checked lock files
define('LOCK_NO_LOCK_FILE', 0);
define('LOCK_FILE_ACTIVE', 1);
define('LOCK_FILE_STALE', 2);

// Library for batch process locking
class Locking {

    protected $CI;
    private $process_id = 0;
    private $process_name = '';
    private $stale_lock_action = LOCK_CLEAR_STALE_NO;
    private $locked_pid = 0;
    private $locked_tries = 0;
    private $lock_dir = '';
    private $lock_file = '';
    private $retries = 1;
    private $status = true;
    private $message = false;

    public function __construct() {
        $this->CI =& get_instance();
        $this->process_id = posix_getpid();
        $this->lock_dir = realpath(BASEPATH.'/../locks');
    }

    // Function to initialize our object
    public function init($process_name, $retries = 1, $stale_lock_action = LOCK_CLEAR_STALE_NO) {
        $this->stale_lock_action = $stale_lock_action;
        $this->process_id = posix_getpid();
        $this->process_name = str_replace(' ', '_', $process_name);
        $this->lock_dir = realpath(BASEPATH.'/../locks');
        $this->lock_file = $this->lock_dir . '/' . $this->process_name . '.lock';
        $this->retries = $retries;
    }

    // Function to check if a lock file exists and if so if its pid is still running
    private function checkLock() {
        if(is_file($this->lock_file)) {
            $pid_data = unserialize(file_get_contents($this->lock_file));
            if(!empty($pid_data)) {
                if($this->checkPid($pid_data['pid'])) {
                    $this->locked_pid = $pid_data['pid'];
                    $this->locked_tries = $pid_data['tries'];
                    return LOCK_FILE_ACTIVE;
                } else {
                    return LOCK_FILE_STALE;
                }
            } else {
                // We didn't have valid data in the lock file, lets just call it stale
                return LOCK_FILE_STALE;
            }
        }
        return LOCK_NO_LOCK_FILE;
    }

    // Check if the passed in pid is running
    private function checkPid($check) {
        if(posix_getpgid($check) !== false) {
            return true;
        }
        return false;
    }

    // Write a lock file, incrementing the tries
    private function writeLock($pid, $tries = 0) {
        $pid_data = serialize(array('pid' => $pid, 'tries' => $tries + 1));
        file_put_contents($this->lock_file, $pid_data);
    }

    // Function to attempt to set a lock.  Returns true on success and false on failure.  On failure will populate $this->message with info
    public function setLock() {
        $status = $this->checkLock();
        if($status == LOCK_NO_LOCK_FILE) {
            // This is the easy one, no lock file exists set one and get outta here
            $this->writeLock($this->process_id);
            return true;
        } elseif($status == LOCK_FILE_STALE)  {
            // We have a stale lock file
            if($this->stale_lock_action == LOCK_CLEAR_STALE_YES) {
                // And we want to clear it automatically, so we simply re-write it
                $this->writeLock($this->process_id);
                return true;
            } else {
                // We don't want to clear it automatically so we don't set our new lock
                $this->message = "Stale lock file exists but you did not specify to auto clear.  Lock failed.";
                $this->status = false;
                return false;
            }
        } elseif($status == LOCK_FILE_ACTIVE) {
            // We have an active lock file, see if we're retrying on it
            if($this->locked_tries <= $this->retries) {
                // Yes, bump the retries in the lock but don't call it an error
                $this->writeLock($this->locked_pid, $this->locked_tries);
                $this->message = "Waiting for locked process to complete. {$this->locked_tries} of {$this->retries} retries";
                return false;
            } else {
                // Fail the lock due to either not retrying or retries exceeded.
                $this->message = "Lock failed.  Previous process still running";
                $this->status = false;
                return false;
            }
        }
    }

    // Clear the current lock file
    public function clearLock() {
        if(is_file($this->lock_file)) {
            if(unlink($this->lock_file)) {
                return true;
            }
        }
        return false;
    }

    // Override the lock dir if desired
    public function setLockDir($lock_dir = false) {
        $lock_dir = realpath($lock_dir);
        if($lock_dir) {
            $this->lock_dir = $lock_dir;
            $this->lock_file = $this->lock_dir . $this->process_name . '.lock';
        }
    }

    public function getStatus() {
        return $this->status;
    }

    public function getMessage() {
        return $this->message;
    }
}
