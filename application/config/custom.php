<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
* This is the config file for the various application settings.  Update 
* to suit your needs
*/

// Email settings.  The default is to use the local systems MTA via PHP's defaults.
$config['smtp_host'] = null;
$config['smtp_port'] = null;
$config['smtp_user'] = null;
$config['smtp_pass'] = null;

// Default from email settings
$config['default_from_email'] = 'no-reply@kissitconsulting.com';
$config['default_from_name'] = 'phpMyAnsibleAdmin';

// Subject for the account activation email
$config['subject_account_activation'] = 'Account Activation';


