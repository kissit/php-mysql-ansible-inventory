
## phpMyAnsibleInventory

A PHP based web interface an manage your Ansible inventory in a MySQL database and an inventory script to make use of it within Ansible.  Also allows for submitting of Ansible tasks from within the UI (feature still under development).

### Requirements

Nothing fancy is needed other than a normal, relatively up to date PHP & MySQL environment.  The UI is based on CodeIgniter 3 so PHP 5.6 is required.

### UI Installation

* Clone/download the repo.  Configure the public/ folder to be the web root.
* Change the system & application path variables ($system_path, $application_folder) in public/index.php if desired.
* Create a MySQL database for the application and optionally a user/password for the application.
* Copy/move application/config/database.php.sample to database.php and modify with your database details.
* Copy/move application/config/config.php.sample to config.php and set $config['base_url'].
* Change application/config/custom.php as desired (not much there yet).
* Load the included sql/install.sql file to seed the database with a minimal dataset.
* The default account is:
  * Username: admin@admin.com 
  * Password: password

### Ansible inventory script installation

Assuming an ansible project with an "inventory" folder.  Copy the scripts/mysql.php file into the inventory folder.  Then add the following to an ansible.cfg in your project:
```
[defaults]
inventory = ./inventory
```

Or, if you'd prefer you can spefify the location when you invoke ansible commands.  For example:
```
ansible-playbook myplaybook.com -i ./inventory/mysql.php
```

### Running of Ansible tasks from within the UI
This feature is still under development, and while generally functional still needs to be made friendlier.  To support tasks do the following.

In application/config/custom.php:
```
$config['tasks_on'] = true;
$config['tasks_log_path'] = '/tmp/tasks';
$config['ansible_project_path'] = '/var/www/phpMyAnsibleAdmin/ansible';
```

Schedule the task runner in cron.  This should be run by the owner that you use to run your ansible commands from CLI.  For example, to check for new tasks every minute:
```
* * * * * /usr/local/bin/php /var/www/phpMyAnsibleAdmin/public/index.php cron/tasks processAnsibleQueue > /dev/null 2>&1
```

### Screenshots
![1login](/screenshots/1login.png?raw=true "Login")

![2home](/screenshots/2home.png?raw=true "Home")

![3servers](/screenshots/3servers.png?raw=true "Servers")

![4edit_server](/screenshots/4edit_server.png?raw=true "Edit Server")

![5groups](/screenshots/5groups.png?raw=true "Groups")

![6edit_group](/screenshots/6edit_group.png?raw=true "Edit Group")

![7submit_task](/screenshots/7submit_task.png?raw=true "Submit ansible task")

![8task_details2](/screenshots/8task_details2.png?raw=true "View task details")

### Credits

To give credit where credit is due the following tools made this easily possible.

* CodeIgniter (still love it, always will.  Just enough framework to help but stays out of the way): http://www.codeigniter.com
* Twig template engine: http://twig.sensiolabs.org
* Twig-Codeigniter library: https://github.com/bmatschullat/Twig-Codeigniter
* CodeIgniter-Ion-Auth library: https://github.com/benedmunds/CodeIgniter-Ion-Auth
* jQuery: https://jquery.com
* Bootstrap: http://getbootstrap.com
* Datatables: https://datatables.net/
* Bootstrap growl: https://github.com/ifightcrime/bootstrap-growl
* Jqueryvalidation plugin: https://jqueryvalidation.org/
* Selectpicker plugin: https://silviomoreto.github.io/bootstrap-select/
* Bootstrap switch plugin: https://github.com/nostalgiaz/bootstrap-switch
* Bootstrap confirmation plugin: http://bootstrap-confirmation.js.org/
* Multiselect plugin: http://loudev.com/#home


Copyright (C) 2017 KISS IT Consulting, LLC.  All rights reserved.