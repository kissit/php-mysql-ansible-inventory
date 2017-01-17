<?php
class Message_model extends MY_model {
    public function __construct() {
        parent::__construct();
        $this->set('table', 'messages');
    }
    
    // Function to set a row in the message table, either new or update
    public function setMessage($message) {
        $id = 0;
        if(isset($message['id'])) {
            $id = (int)$message['id'];
            unset($message['id']);
        }
        return $this->setRow($id, $message);
    }
}