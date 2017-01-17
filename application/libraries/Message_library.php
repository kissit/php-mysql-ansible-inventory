<?php defined('BASEPATH') OR exit('No direct script access allowed');

// Library for sending email messages
class Message_library {

    protected $CI;
    protected $email_config = array();

    public function __construct() {
        $this->CI =& get_instance();
        $this->CI->load->model('message_model');
        $this->CI->load->library('email');

        // Initialize our email config
        $this->email_config = array('mailtype' => 'html');
        $smtp_host = $this->CI->config_model->getOption('smtp_host');
        if(!empty($smtp_host)) {
            $smtp_port = $this->CI->config_model->getOption('smtp_port');
            $smtp_user = $this->CI->config_model->getOption('smtp_user');
            $smtp_pass = $this->CI->config_model->getOption('smtp_pass');

            $this->email_config['protocol'] = 'smtp';
            $this->email_config['smtp_host'] = $smtp_host;
            $this->email_config['smtp_port'] = !empty($smtp_port) ? $smtp_port : '25';
            $this->email_config['smtp_user'] = !empty($smtp_user) ? $smtp_user : '';
            $this->email_config['smtp_pass'] = !empty($smtp_pass) ? $smtp_pass : '';
        }
    }

    // Generic function to send an email using configuration defaults when needed
    public function sendEmail($message, $format = 'html', $log = false) {
        if(isset($message['to'])) {
            // If we don't have "from" info use the defaults configured for the system
            if(!isset($message['from_email'])) {
                $message['from_email'] = $this->CI->config_model->getOption('default_from_email');
            }
            if(!isset($message['from_name'])) {
                $message['from_name'] = $this->CI->config_model->getOption('default_from_name');
            }

            // Initialize and send the message
            $this->email_config['mailtype'] = $format;
            $this->CI->email->initialize($this->email_config);
            $this->CI->email->from($message['from_email'], $message['from_name']);
            $this->CI->email->to($message['to']);
            $this->CI->email->subject($message['subject']);
            $this->CI->email->message($message['message']);
            if(isset($message['alt_message']) && !empty($message['alt_message'])) {
                $this->CI->email->set_alt_message($message['alt_message']);
            }
            if(isset($message['attachment']) && !empty($message['attachment'])) {
                $this->CI->email->attach($message['attachment']);
            }
            $return = $this->CI->email->send();
            
            // If we want to log the message do so
            if($return && $log) {
                $message['status'] = 'sent';
                $this->CI->message_model->setMessage($message);
            }

            return $return;
        } else {
            return false;
        }
    }

   
}