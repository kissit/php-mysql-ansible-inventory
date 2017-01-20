<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Servers extends MY_Controller {

    public function __construct() {
        parent::__construct();
        $this->requireLoggedInUser();
        $this->load->model('servers_model');
    }

    public function index() {
        $data = array();
        $data['rows'] = $this->servers_model->getRows();
        $this->templateDisplay('servers/index.tpl', $data);
    }

    public function edit($id = 0) {
        $data = array();
        $id = (int)$id;
        if($id > 0) {
            $data['server'] = $this->servers_model->getRow($id);
        }
        $this->templateDisplay('servers/edit.tpl', $data);
    }
}
