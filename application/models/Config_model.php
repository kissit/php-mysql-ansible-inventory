<?php
class Config_model extends MY_Model {
    public function __construct() {
        $this->load->database();
        $this->setAll(array('table' => 'config', 'id' => 'name', 'name' => 'value'));
    }
    // Function go get all configuration options
    public function getOptions() {
        return $this->getRows(array(), null, 'name ASC');
    }
    // Function to get the value of a single variable
    public function getOption($name, $return_row = false) {
        if(!empty($name)) {
            $row = $this->getRow($name);
            if(!empty($row)) {
                if($return_row) {
                    $return = $row;
                } else {
                    $return = trim($row['value']);
                }
                return $return;
            }
        }
        return false;
    }
    // Function to set an option, either by inserting or updating an existing one
    public function setOption($data) {
        if(isset($data['name']) && isset($data['value'])) {
            $name = $this->db->escape($data['name']);
            $value = $this->db->escape(trim($data['value']));
            $query = $this->db->query("INSERT INTO config(name, value) VALUES($name, $value) ON DUPLICATE KEY UPDATE value = $value");
        }
    }
    // Function to delete an option
    public function deleteOption($name) {
        $this->deleteRow($name);
    }
}
