<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Batch_model extends MY_Model {


    public function __construct() {
        parent::__construct();
        $this->set('table', 'batch');
    }

}
