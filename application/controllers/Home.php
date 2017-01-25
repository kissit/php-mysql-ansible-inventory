<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Home extends MY_Controller {

    public function __construct() {
        parent::__construct();
    }

    // Display the main page/login screen
    public function index() {
        $data = array();
        $this->templateDisplay('home/home.tpl', $data);
    }

    // Display the user profile screen (if user is logged in)
    public function profile() {
        $this->requireLoggedInUser();
        $data['min_password_length'] = $this->config->item('min_password_length', 'ion_auth');
        $data['max_password_length'] = $this->config->item('max_password_length', 'ion_auth');
        $data['user'] = $this->getUser();
        $this->templateDisplay('admin/edit_user.tpl', $data);
    }

    // Handle the user updating their profile
    public function setProfile() {
        $this->requireLoggedInUser();
        $data = (array)$this->input->post('user');

        // Update the password if needed
        if($this->input->post('password1')) {
            $data['password'] = $this->input->post('password1');
        }

        // Do the update and return
        if($this->ion_auth->update($this->getUserId(), $data)) {
            $this->setMessage($this->ion_auth->messages());
        } else {
            $this->setMessage($this->ion_auth->errors(), 'danger');   
        }
        redirect("/profile");
    }
}