<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Login extends MY_Controller {

    public function __construct() {
        parent::__construct();
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

    // Display the login page (which in our case is the main page)
    public function index() {
        redirect("/");
    }

    // Function to check if an email address is available to be used for a new registration.  
    // Returns the result as per the Jquery validation spec for the remote validator: https://jqueryvalidation.org/remote-method/ 
    public function checkRegEmail() {
        $email = strtolower(trim($this->input->post('email')));
        $email_old = strtolower(trim($this->input->post('email_old')));
        $check = $this->ion_auth->where('email', $email)->users()->row();
        if(empty($check)) {
            $return = 'true';
        } else {
            if($email_old == $email) {
                $return = 'true';
            } else {
                $return = "Email already in use";
            }
        }
        $this->returnJson($return);
    }

    // Process a login request from the form
    public function login() {
        $email = strtolower(trim($this->input->post('email')));
        $password = $this->input->post('password');
        $remember = (bool)$this->input->post('remember');
        
        if ($this->ion_auth->login($email, $password, $remember)) {
            // Figure out where to send them
            $redirect = $this->session->flashdata('login_redirect');
            if(empty($redirect)) {
                $redirect = "/";
            }
            $return = array('redir' => $redirect);
        } else {
            $return = array('message' => $this->ion_auth->errors());
        }
        $this->returnJson($return);
    }

    // Process a logout request
    public function logout() {
        $this->input->set_cookie('login_expires', 0, '');
        $logout = $this->ion_auth->logout();
        redirect("/");
    }

    // Function to handle the user clicking on an account activation link
    public function activate($id, $code) {
        $activation = $this->ion_auth->activate($id, $code);
        if($activation) {
            // Force the user to set their password
            $identity = $this->ion_auth->where('id', $id)->users()->row();
            $forgot = $this->ion_auth->forgotten_password($identity->{$this->config->item('identity', 'ion_auth')});
            $forgot['forgotten_password_code'] = urlencode($forgot['forgotten_password_code']);
            redirect("/reset/{$forgot['forgotten_password_code']}");
        } else {
            $this->setMessage();
        }
        redirect("/");
    }

    // Display the recover password page
    public function recover() {
        if ($this->getLoggedIn()) {
            redirect("/user");
        }
        $data = array('browser_title' => 'BackerNation Password Recovery');
        $this->templateDisplay('login/recover.tpl', $data);
    }

    // Process the recover password form
    public function doRecover() {
        $email = strtolower(trim($this->input->post('email')));

        // check that this user exists
        $identity = $this->ion_auth->where('email', $email)->users()->row();
        if(empty($identity)) {
            // Here, we just return a message saying it was processed, but we didn't actually find a matching account.
            $this->setMessage("Your password recovery request has been processed and an email was sent to you with further instructions.");
        } else {
            // Process the reset
            $this->load->library('messages');
            $forgot = $this->ion_auth->forgotten_password($identity->{$this->config->item('identity', 'ion_auth')});
            if(!empty($forgot)) {
                // Send the email
                $data = array();
                $forgot_code = urlencode($forgot['forgotten_password_code']);
                $data['reset_password_link'] = site_url("reset/{$forgot_code}");
                $data['name'] = $identity->first_name;
                $this->messages->sendTemplateEmail('password_reset', $forgot['identity'], $data);
                $this->setMessage($this->ion_auth->messages());
            } else {
                $this->setMessage($this->ion_auth->messages(), 'danger');
            }
        }
        redirect("/");
    }

    // Function to handle the user clicking the reset password link from their email
    public function reset($code) {
        $user = $this->ion_auth->forgotten_password_check($code);
        if($user) {
            $data = array();
            $data['user_id'] = $user->id;
            $data['csrf'] = $this->getNonce();
            $data['code'] = $code;
            $data['min_password_length'] = $this->config->item('min_password_length', 'ion_auth');
            $data['max_password_length'] = $this->config->item('max_password_length', 'ion_auth');
            $this->templateDisplay('login/reset.tpl', $data);            
        } else {
            $this->setMessage();
            redirect("/recover");
        }
    }

    // Function to process a submit of the reset password form
    public function doReset() {
        $redirect = "/";
        // First check our nonce and user that they match
        $code = $this->input->post('code');
        $user = $this->ion_auth->forgotten_password_check($code);
        if ($this->checkNonce() === FALSE || $user->id != $this->input->post('user_id')) {
            // If we get here someone may be trying to force their way into someone's account.  Clear their code.
            $this->ion_auth->clear_forgotten_password_code($code);
            $this->setMessage();
        } else {
            // finally change the password
            $identity = $user->{$this->config->item('identity', 'ion_auth')};
            $change = $this->ion_auth->reset_password($identity, $this->input->post('password'));
            if ($change) {
                $this->setMessage($this->ion_auth->messages(), 'success');
            } else {
                $this->setMessage($this->ion_auth->errors(), 'danger');
                redirect("/reset/$code");
            }
        }
        redirect($redirect);
    }
}
