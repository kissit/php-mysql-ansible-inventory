<?php
// Our custom controller class that is used for pages that require authentication.
class Admin_Controller extends MY_Controller 
{
    protected $header_data = array('selected_menu' => '', 'selected_submenu' => '', 'is_admin' => false);

    protected $user = null;
    protected $user_id = 0;
    protected $is_admin = false;

    public function __construct() {
        parent::__construct();

        // If user not logged in, send them there
        if (!$this->getLoggedIn()) {
            redirect('/admin/login');
        }

        // Set a few items we'll always be looking for
        $this->user = $this->ion_auth->user()->row();
        $this->user_id = $this->user->id;
        $this->is_admin = $this->ion_auth->is_admin($this->user_id);
        $this->header_data['first_name'] = $this->user->first_name;
        $this->header_data['is_admin'] = $this->is_admin;
    }

    // Simple getters for the user info
    public function getUserId() {
        return $this->user_id;
    }
    public function getUser($attr = null) {
        if($attr && isset($this->user->$attr)) {
            return $this->user->$attr;
        } else {
            return $this->user;
        }
    }
    public function isAdmin() {
        return $this->is_admin;
    }

    // Function to set the current Menu.  Technically only required when the current page is not one thats found in the menu definition.
    protected function setMenu($menu) {
        $this->header_data['selected_menu'] = $menu;
    }

    // Function to set the current Sub Menu.  Technically only required when the current page is not one thats found in the menu definition.
    protected function setSubmenu($submenu) {
        $this->header_data['selected_submenu'] = $submenu;
    }

    // Wrapper function to display a template to the page.
    protected function templateDisplay($template, $data) {
        $data['header_data'] = $this->header_data;
        $data['header_data']['status'] = $this->session->flashdata('status');
        $data['header_data']['message'] = $this->session->flashdata('message');
        $this->template->display($data, $template);
    }

}