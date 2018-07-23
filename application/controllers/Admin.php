<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Admin extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
    }

    public function cleanup() {
        $data = array();
        //$data['rows'] = $this->ion_auth->users()->result_array();
        $this->templateDisplay('admin/cleanup.tpl', $data);
    }

    public function users() {
        $data = array();
        $data['rows'] = $this->ion_auth->users()->result_array();
        $this->templateDisplay('admin/users.tpl', $data);
    }

    public function editUser($id = 0) {
        $id = (int)$id;
        $data = array('admin_edit' => true);
        $data['min_password_length'] = $this->config->item('min_password_length', 'ion_auth');
        $data['max_password_length'] = $this->config->item('max_password_length', 'ion_auth');

        if($id > 0) {
            $data['user'] = $this->ion_auth->user($id)->row();
            $status = $data['user']->active;
        } else {
            $status = 1;
        }
        $data['status_options'] = $this->getStatusOptions($status);

        $this->templateDisplay('admin/edit_user.tpl', $data);
    }

    // Function to add/update a user, including password if set
    public function processEditUser() {
        $data = $this->input->post('user');
        $id = (int)$this->input->post('id');
        $status = true;

        if(isset($data['email']) && !empty($data['email'])) {
            $additional_data = array();
            $additional_data['first_name'] = $data['first_name'];
            $additional_data['last_name'] = $data['last_name'];

            // Update the password if needed
            if($this->input->post('password1')) {
                // Set the password in the update array since its there
                $data['password'] = $this->input->post('password1');
            }

            // Get our status, if not set then they are inactive.
            $additional_data['active'] = (int)$this->input->post('active');
            $data['active'] = $additional_data['active'];

            if($id > 0) {
                // Update an existing user
                if($this->ion_auth->update($id, $data)) {
                    $this->setMessage($this->ion_auth->messages());
                } else {
                    $this->setMessage($this->ion_auth->errors(), 'danger');
                    redirect("/admin/editUser/$id");
                }
            } else {
                // Create a new user
                $user = $this->ion_auth->register($data['email'], '', $data['email'], $additional_data);
                if(!empty($user)) {
                    // For now lets just make everyone an admin.  If we break out roles later then the initial users will not break
                    $this->ion_auth->add_to_group(1, $user['id']);

                    // Configure our template data & send the confirmation email
                    $this->load->library('messages');
                    $data = array();
                    $user['activation'] = urlencode($user['activation']);
                    $data['activation_link'] = site_url("activate/{$user['id']}/{$user['activation']}");
                    $this->messages->sendTemplateEmail('account_activation', $user['email'], $data);

                    $this->setMessage("User successfully created and activation email sent");
                } else {
                    $this->setMessage($this->ion_auth->errors(), 'danger');
                    redirect("admin/user/editUser");
                }
            }
        }
        redirect("/admin/users");
    }
}
