<?php
// Our base controller class that we use to extend the CI controller to provide various helper functionality that we'll
// frequently use.  Note this controller DOES NOT require a user to be authenticated so should only be used on public pages.
class MY_Controller extends CI_Controller {

    private $statuses = array(1 => 'Active', 0 => 'Inactive', );
    private $logged_in = false;
    protected $user = null;
    protected $user_id = 0;
    protected $user_display_name = null;
    protected $is_admin = false;
    protected $mytime = 0;
    protected $mydatetime = '';
    protected $default_error_message = "Something went wrong while processing your request";

    public function __construct() {
        parent::__construct();
        
        // Load our custom config
        $this->config->load('custom', TRUE);

        // Check if we have a logged in user
        $this->load->library('ion_auth');
        $this->setLoggedIn($this->ion_auth->logged_in());
        $this->mytime = time();
        $this->mydatetime = date('Y-m-d H:i:s', $this->mytime);

        // Set a few items we'll always be looking for on pages requiring a logged in user
        if($this->getLoggedIn()) {
            $this->setUser($this->ion_auth->user()->row());
            $this->setUserId($this->user->id);
            $this->setIsAdmin($this->ion_auth->is_admin($this->getUserId()));
            $this->setUserDisplayName($this->user->first_name);
        }
    }

    // Helper debug function that you'll see in various classes cause this is how I like to debug stuff
    protected function debug($var, $exit = false) {
        echo "<pre>";
        var_dump($var);
        echo "</pre>";
        if($exit) {
            exit;
        }
    }

    // Simple shared function to check if a user is logged in and if not send them to the login page.
    // Mainly for public controllers that to not extend a controller requiring login but do need some functions to be secured
    public function requireLoggedInUser() {
        if (!$this->getLoggedIn()) {
            $this->setLoginRedirect(current_url());
            redirect('/login');
        }
    }

    // Function to set the login_redirect setting in the flashdata
    public function setLoginRedirect($url) {
        if(!empty($url) && strpos($url, '/login') === false) {
            $this->session->set_flashdata('login_redirect', $url);
        }
    }

    // Simple setters/getters for the user info
    protected function setUserId($set) {
        $this->user_id = $set;
    }
    public function getUserId() {
        return $this->user_id;
    }
    protected function setUser($set) {
        $this->user = $set;
    }
    public function getUser($attr = null) {
        if($attr && isset($this->user->$attr)) {
            return $this->user->$attr;
        } else {
            return $this->user;
        }
    }
    protected function setUserDisplayName($set) {
        $this->user_display_name = !empty($set) ? $set : 'No Name';
    }
    public function getUserDisplayName() {
        return $this->user_display_name;
    }
    protected function setIsAdmin($set) {
        $this->is_admin = $set;
    }
    public function isAdmin() {
        return $this->is_admin;
    }
    protected function setLoggedIn($set) {
        $this->logged_in = $set;
    }
    public function getLoggedIn() {
        return $this->logged_in;
    }
    public function getMyDateTime() {
        return $this->mydatetime;
    }
    public function getMyTime() {
        return $this->mytime;
    }

    // method to return the textual representation of a status id
    protected function getStatusName($id) {
        return isset($this->statuses[$id]) ? $this->statuses[$id]['name'] : '';
    }

    // Method to return the status of a row of data if it exists
    protected function getRowStatus($row, $default = 0) {
        return isset($row['status']) ? $row['status'] : $default;
    }

    // Method to return an array of dropdown list options containing statuses, optionally with one selected
    protected function getStatusOptions($selected = 0) {
        return $this->getOptions($this->statuses, $selected);
    }

    // Method to get our default error message
    protected function getDefaultErrorMessage() {
        return $this->default_error_message;
    }

    // Method to set a flash message to be used by the built in notification system.  Passing no message displays the default error message
    protected function setMessage($message, $status = 'success') {
        if(empty($message)) {
            // Set our default message
            $message = $this->getDefaultErrorMessage();
            $status = "danger";
        }
        $this->session->set_flashdata('flash_status', $status);
        $this->session->set_flashdata('flash_message', $message);
    }

    // Method to return an array of dropdown list options based on the passed in array of value => name pairs & selected item
    protected function getOptions($options, $selected = 0) {
        $return = array();
        foreach($options as $value => $name) {
            $select = $selected == $value ? 'selected' : '';
            $return[] = "<option value=\"$value\" $select>$name</option>";
        }
        return $return;
    }

    // Method to return an array of dropdown list options based on the passed in array OF ROWS & selected item
    protected function getOptionsFromRows($options, $selected = 0, $name_key = 'name', $id_key = 'id') {
        $return = array();
        foreach($options as $option) {
            $select = $selected == $option[$id_key] ? 'selected' : '';
            $return[] = "<option value=\"{$option[$id_key]}\" $select>{$option[$name_key]}</option>";
        }
        return $return;
    }

    // Method to return a lookup array of key => value pairs from a flat array of rows
    protected function getLookups($options, $name_key = 'name', $id_key = 'id') {
        $return = array();
        foreach($options as $option) {
            $return[$option[$id_key]] = $option[$name_key];
        }
        return $return;
    }

    // Function to output a json response for an ajax request (or any other request that needs json)
    public function returnJson($return) {
        $this->output->set_content_type('application/json');
        $this->output->set_output(json_encode($return));
    }

    // Wrapper function to display a template to the page.
    protected function templateDisplay($template, $data, $set_og = true) {
        $data['is_logged_in'] = $this->getLoggedIn();
        $data['users_id'] = $this->getUserId();
        $data['flash_status'] = $this->session->flashdata('flash_status');
        $data['flash_message'] = $this->session->flashdata('flash_message');
        $data['user_display_name'] = $this->getUserDisplayName();
        $data['site_url'] = site_url();

        $this->template->display($data, $template);
    }
}
