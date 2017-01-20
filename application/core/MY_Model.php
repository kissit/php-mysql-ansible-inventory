<?php
// Our base model that we'll extend in other models
class MY_model extends CI_Model {

    // These our common table parts vars that are for the most part shared across all models.
    // Define your tables consistently and they can stay just like so
    protected $table = null;
    protected $id = 'id';
    protected $name = 'name';
    protected $status = 'status';

    protected $mytime = null;
    protected $mydate = null;
    protected $mydatetime = null;

    public function __construct() {
        parent::__construct();
        $this->load->database();
        $this->mytime = time();
        $this->mydate = date('Y-m-d', $this->mytime);
        $this->mydatetime = date('Y-m-d H:i:s', $this->mytime);
    }

    public function getMyDateTime() {
        return $this->mydatetime;
    }
    public function getMyTime() {
        return $this->mytime;
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

    // Helper debug function to dump the last query
    public function debugLastQuery($exit = false) {
        echo "<pre>";
        echo $this->db->last_query();
        echo "</pre>";
        if($exit) {
            exit;
        }
    }

    // Helper function to escape manually when needed
    public function escape($str, $like = false) {
        if($like) {
            return $this->db->escape_like_str($str);
        } else {
            return $this->db->escape_str($str);
        }
    }

    // Generic setter for an array of things we want to set all at once
    public function setAll($vars) {
        if(is_array($vars)) {
            foreach($vars as $var => $value) {
                $this->set($var, $value);
            }
        }
    }

    // Generic setter for whatever we may need
    public function set($var, $value) {
        $this->{$var} = $value;
    }

    // Generic getter for whatever we may need
    public function get($var) {
        if(isset($this->{$var})) {
            return $this->{$var};
        } else {
            return false;
        }
    }

    // Method to negotiate the table name
    protected function getTableName($table) {
        if(!$table) {
            $table = $this->table;
        }
        return $table;
    }

    // Method to generically get a single data point from the database based on our current table and various options
    // If more than one rows match you'll only get the first.  This assumes you're doing lookups on unique criteria
    public function getOne($column, $where, $table = null) {
        if(!empty($column) && !empty($where)) {
            $this->db->select($column);
            $this->db->where($where);
            $query = $this->db->get($this->getTableName($table));
            $row = $query->row_array();
            if(!empty($row)) {
                return $row[$column];
            }
        }
        return false;
    }

    // Method to get a row from the database based on our current table/id colum/etc
    public function getRow($id, $table = null) {
        if(!empty($id)) {
            $table = $this->getTableName($table);
            $query = $this->db->get_where($table, array($this->id => $id));
            return $query->row_array();
        }
        return false;
    }

    // Method to generically get rows from the database based on our current table and various options
    public function getRows($where = array(), $table = null, $order = null, $limit = null) {
        if(!empty($order)) {
            if(is_array($order)) {
                $order = implode(', ', $order);
            }
            $this->db->order_by($order);
        }
        if(is_array($limit) && !empty($limit)) {
            if(count($limit) == 1) {
                $this->db->limit($limit[0]);
            } else {
                $this->db->limit($limit[0], $limit[1]);
            }
        }
        if(!empty($where)) {
            $this->db->where($where);
        }

        $query = $this->db->get($this->getTableName($table));
        return $query->result_array();
    }

    // Method to get a row count based on our current table and optionally passed in where array
    public function getRowsCount($where = array(), $table = null) {
        $this->db->where($where);
        return $this->db->count_all_results($this->getTableName($table));
    }

    // Method to set a row into a database table.  Either insert or update based on id
    public function setRow($id, $row, $table = null) {
        if(!empty($row)) {
            if(!empty($id)) {
                if($this->db->update($this->getTableName($table), $row, array($this->id => $id))) {
                    return $id;
                }
            } else {
                $this->db->insert($this->getTableName($table), $row);
                return $this->db->insert_id();
            }
        }
        return false;
    }

    // Method to set a row into a database table using insert or update based on whether or not the ID is present yet
    public function insertUpdateRow($id, $row, $table = null) {
        if(!empty($row)) {
            $check = $this->getRowsCount(array($this->id => $id), $table);
            if($check > 0) {
                if($this->db->update($this->getTableName($table), $row, array($this->id => $id))) {
                    return $id;
                }
            } else {
                $row[$this->id] = $id;
                $this->db->insert($this->getTableName($table), $row);
                return $this->db->insert_id();
            }
        }
        return false;
    }

    // Generic function to delete a row from a database table
    public function deleteRow($id, $table = null) {
        return $this->db->delete($this->getTableName($table), array($this->id => $id));
    }

    // Generic function to delete from a database table based on a where array
    public function deleteWhere($where = array(), $table = null) {
        return $this->db->delete($this->getTableName($table), $where);
    }

    // Generic function to update a database table based on a where array
    public function updateWhere($where = array(), $update = array(), $table = null) {
        return $this->db->update($this->getTableName($table), $update, $where);
    }
}
