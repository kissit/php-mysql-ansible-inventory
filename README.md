
## NOTE: This project is under active development as of 1/16/2017 and should be ready soon.

## php-mysql-ansible-inventory

A PHP based web interface an manage your Ansible inventory in a MySQL database and an inventory script to make use of it within Ansible.

### Requirements

Nothing fancy is needed other than a normal, relatively up to date PHP & MySQL environment.  The UI is based on CodeIgniter so PHP 5.6 is required.

### UI Installation

* Clone/download the repo.  Configure the public/ folder to be the web root.
* Change the system & application path variables ($system_path, $application_folder) in public/index.php if desired.
* Create a MySQL database for the application and optionally a user/password for the application.
* Copy/move application/config/database.php.sample to database.php and modify with your database details.
* Copy/move application/config/config.php.sample to config.php and set $config['base_url'].
* Load the included sql/install.sql file to seed the database with a minimal dataset.
* The default account is:
  * Username: admin@admin.com 
  * Password: password

### Ansible inventory script installation

TODO

### Credits

To give credit where credit is due the following tools made this easily possible.

* CodeIgniter (still love it, always will.  Just enough framework to help but stays out of the way): http://www.codeigniter.com
* Twig template engine: http://twig.sensiolabs.org
* Twig-Codeigniter library: https://github.com/bmatschullat/Twig-Codeigniter
* CodeIgniter-Ion-Auth library: https://github.com/benedmunds/CodeIgniter-Ion-Auth
* jQuery: https://jquery.com
* jQuery Form Validator plugin: http://formvalidator.net
* Bootstrap: http://getbootstrap.com


Copyright (C) 2017 KISS IT Consulting, LLC.  All rights reserved.