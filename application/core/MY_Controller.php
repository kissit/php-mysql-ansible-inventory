<?php
// Our base controller class that we use to extend the CI controller to provide various helper functionality that we'll
// frequently use.  Note this controller DOES NOT require a user to be authenticated so should only be used on public pages.
require(APPPATH.'core/Admin_Controller.php');
class MY_Controller extends CI_Controller
{
    private $statuses = array(0 => array('id' => 0, 'name' => 'Inactive'), 1 => array('id' => 1, 'name' => 'Active'));
    private $logged_in = false;

    public function __construct() {
        parent::__construct();

        // Check if we have a logged in user
        $this->load->library('ion_auth');
        $this->logged_in = $this->ion_auth->logged_in();
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

    // Getter for our logged in status
    protected function getLoggedIn() {
        return $this->logged_in;
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

    // Method to set a flash message to be used by the built in notification section
    protected function setMessage($message, $status = 'success') {
        $this->session->set_flashdata('status', $status);
        $this->session->set_flashdata('message', $message);
    }

    // Method to return an array of dropdown list options based on the passed in array & selected item
    protected function getOptions($options, $selected = 0, $name_key = 'name', $id_key = 'id') {
        $return = array();
        foreach($options as $option) {
            $select = '';
            if($selected == $option[$id_key]) {
                $select = 'selected';
            }
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

    // Wrapper function to display a template to the page.
    protected function templateDisplay($template, $data) {
        $data['is_logged_in'] = $this->getLoggedIn();
        $this->template->display($data, $template);
    }
}
