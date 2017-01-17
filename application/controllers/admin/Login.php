<?php
defined('BASEPATH') OR exit('No direct script access allowed');
// Login controller.  Note that we don't extend the controller here cause we aren't authenticated yet
class Login extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->library('ion_auth');
    }

    // functions to get and set a NONCE value to use when we want to make sure a request is only made once
    private function getNonce() {
        $this->load->helper('string');
        $key = random_string('alnum', 8);
        $value = random_string('alnum', 20);
        $this->session->set_flashdata('csrfkey', $key);
        $this->session->set_flashdata('csrfvalue', $value);
        return array('key' => $key, 'value' => $value);
    }
    private function checkNonce() {
        if ($this->input->post($this->session->flashdata('csrfkey')) !== FALSE && $this->input->post($this->session->flashdata('csrfkey')) == $this->session->flashdata('csrfvalue')) {
            return true;
        } else {
            return false;
        }
    }

    // Display the login page
    public function index() {
        if ($this->ion_auth->logged_in()) {
            redirect("/admin");
        }
        $data['message'] = $this->session->flashdata('message');
        $data['message_type'] = $this->session->flashdata('message_type');
        $data['title'] = 'Login';

        $this->template->display($data, 'admin/login.tpl');
    }

    // Process a login request from the form
    public function login() {
        $email = $this->input->post('email');
        $password = $this->input->post('password');
        $remember = (bool)$this->input->post('remember');
        
        if ($this->ion_auth->login($email, $password, $remember)) {
            redirect("/admin");
        } else {
            $this->session->set_flashdata('message', $this->ion_auth->errors());
            redirect("/login");
        }
    }

    // Process a logout request
    public function logout() {
        $logout = $this->ion_auth->logout();
        redirect("/login");
    }

    // Display the reset password page
    public function reset() {
        if ($this->ion_auth->logged_in()) {
            redirect("/admin");
        }
        $data['message'] = $this->session->flashdata('message');
        $data['title'] = 'Reset Password';

        $this->template->display($data, 'admin/reset.tpl');
    }

    // Process the reset password form submit
    public function doReset() {
        $email = strtolower($this->input->post('email'));
        
        // check that this user exists
        $identity = $this->ion_auth->where('email', $email)->users()->row();
        if(empty($identity)) {
            $this->session->set_flashdata('message', "The email address you entered was not found, please try again.");
            redirect("/admin/login/reset");
            exit;
        }
        
        // Process the reset
        $this->load->library('message_library');
        $forgot = $this->ion_auth->forgotten_password($identity->{$this->config->item('identity', 'ion_auth')});
        if(!empty($forgot)) {
            // Configure our template data
            $data = array();
            $data['heading'] = "Password Reset - " . $this->config_model->getOption('site_name');
            $forgot['forgotten_password_code'] = urlencode($forgot['forgotten_password_code']);
            $data['reset_password_link'] = site_url("reset_password/{$forgot['forgotten_password_code']}");
            $data['contact_form_url'] = site_url("/contact");

            // Send the email
            $message = array();
            $message['to'] = $forgot['identity'];
            $message['subject'] = $data['heading'];
            $message['message'] = $this->template->render($data, true, 'messages/password_reset_email_html.tpl');
            $message['alt_message'] = $this->template->render($data, true, 'messages/password_reset_email_text.tpl');
            $this->message_library->sendEmail($message);

            // Set user message and send them back to the login page
            $this->session->set_flashdata('message_type', 'alert-success');
            $this->session->set_flashdata('message', $this->ion_auth->messages());
            redirect("/login");
        } else {
            $this->session->set_flashdata('message', $this->ion_auth->messages());
            redirect("/admin/login/reset");
        }
    }

    // Function to handle the user clicking on an account activation link
    public function activateAccount($id, $code) {
        $activation = $this->ion_auth->activate($id, $code);
        if($activation) {
            $identity = $this->ion_auth->where('id', $id)->users()->row();
            $forgot = $this->ion_auth->forgotten_password($identity->{$this->config->item('identity', 'ion_auth')});
            $forgot['forgotten_password_code'] = urlencode($forgot['forgotten_password_code']);
            redirect("/reset_password/{$forgot['forgotten_password_code']}");
        } else {
            redirect("/");
        }
    }

    // Function to handle the user clicking the reset password link from their email
    public function resetPassword($code) {
        $user = $this->ion_auth->forgotten_password_check($code);
        if($user) {
            $data = array();
            $data['user_id'] = $user->id;
            $data['csrf'] = $this->getNonce();
            $data['code'] = $code;
            $data['min_password_length'] = $this->config->item('min_password_length', 'ion_auth');
            $data['max_password_length'] = $this->config->item('max_password_length', 'ion_auth');
            $this->template->display($data, 'admin/reset_password.tpl');            
        } else {
            $this->session->set_flashdata('message', $this->ion_auth->errors());
            redirect("/admin/login/reset");
        }
    }

    public function doResetPassword() {
        // First check our nonce and user that they match
        $code = $this->input->post('code');
        $user = $this->ion_auth->forgotten_password_check($code);
        if ($this->checkNonce() === FALSE || $user->id != $this->input->post('user_id')) {
            // If we get here someone may be trying to force their way into someone's account.  Clear their code.
            $this->ion_auth->clear_forgotten_password_code($code);
            redirect("/admin/login/reset");
        } else {
            // finally change the password
            $identity = $user->{$this->config->item('identity', 'ion_auth')};
            $change = $this->ion_auth->reset_password($identity, $this->input->post('pass'));
            if ($change) {
                $this->session->set_flashdata('message_type', 'alert-success');
                $this->session->set_flashdata('message', $this->ion_auth->messages());
                redirect("/login");
            } else {
                $this->session->set_flashdata('message', $this->ion_auth->errors());
                redirect("/reset_password/$code");
            }
        }
    }
}