<?php defined('BASEPATH') OR exit('No direct script access allowed');

// Library for sending email messages
class Messages {

    protected $CI;
    protected $email_config = array();

    public function __construct() {
        $this->CI =& get_instance();
        $this->CI->load->library('email');

        // Initialize our email config
        $this->email_config = array('mailtype' => 'html');
        if(!empty($this->CI->config->item('smtp_host', 'custom'))) {
            $this->email_config['protocol'] = 'smtp';
            $this->email_config['smtp_host'] = $this->CI->config->item('smtp_host', 'custom');
            $this->email_config['smtp_port'] = !empty($this->CI->config->item('smtp_port', 'custom')) ? $this->CI->config->item('smtp_port', 'custom') : '25';
            $this->email_config['smtp_user'] = !empty($this->CI->config->item('smtp_user', 'custom')) ? $this->CI->config->item('smtp_user', 'custom') : '';
            $this->email_config['smtp_pass'] = !empty($this->CI->config->item('smtp_pass', 'custom')) ? $this->CI->config->item('smtp_pass', 'custom') : '';
        }
    }

    // Generic function to send an email using configuration defaults when needed
    public function sendEmail($message, $format = 'html') {
        if(isset($message['to'])) {
            // If we don't have "from" info use the defaults configured for the system
            if(!isset($message['from_email']) || empty($message['from_email'])) {
                $message['from_email'] = (string)$this->CI->config->item('default_from_email', 'custom');
            }
            if(!isset($message['from_name']) || empty($message['from_name'])) {
                $message['from_name'] = (string)$this->CI->config->item('default_from_name', 'custom');
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
            return $this->CI->email->send();
        } else {
            return false;
        }
    }

    // Generic function to send an email that we have defined a template for
    public function sendTemplateEmail($type, $to, $data, $subject = '') {
        if(!empty($type) && !empty($to)) {
            if(empty($subject)) {
                $subject = (string)$this->CI->config->item("subject_{$type}", 'custom');
            }
            $message = array('to' => $to);
            $data['subject'] = $subject;
            $data['site_url'] = site_url();
            $message['subject'] = $data['subject'];
            $message['from_email'] = isset($data['from_email']) ? $data['from_email'] : null;
            $message['from_name'] = isset($data['from_name']) ? $data['from_name'] : null;
            $message['message'] = $this->CI->template->render($data, true, "email_templates/{$type}_html.tpl");
            $message['alt_message'] = $this->CI->template->render($data, true, "email_templates/{$type}_text.tpl");
            return $this->sendEmail($message);
        }
        return false;
    }   
}
