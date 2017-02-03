<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
* This is the config file for the various application settings.  Update 
* to suit your needs
*/

// Whether or not to enable the Ansible tasks functionality which will allow web users to run tasks
// Set this to 'false' to disable
$config['tasks_on'] = true;

// The location to write your ansible tasks output logs to.  This location must be writeable by the
// user running the tasks script.  It must also be readable by the web server.
// DO NOT INCLUDE TRAILING /
$config['tasks_log_path'] = '/tmp/tasks';
$config['ansible_project_path'] = '/home/brian/public_repos/phpMyAnsibleAdmin/ansible';

// Email settings.  The default is to use the local systems MTA via PHP's defaults.
$config['smtp_host'] = null;
$config['smtp_port'] = null;
$config['smtp_user'] = null;
$config['smtp_pass'] = null;

// Default from email settings
$config['default_from_email'] = 'no-reply@domain.com';
$config['default_from_name'] = 'phpMyAnsibleAdmin';

// Subject for the account activation email
$config['subject_account_activation'] = 'Account Activation';


