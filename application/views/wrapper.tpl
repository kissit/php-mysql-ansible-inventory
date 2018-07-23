<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>{{ browser_title is not empty ? browser_title : 'phpMyAnsibleAdmin' }}</title>
    <!-- Bootstrap CSS -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- Datatables Bootstrap CSS -->
    <link href="//cdn.datatables.net/1.10.8/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <!-- Start Bootstrap Template -- small business -->
    <link href="/css/small-business.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- Bootstrap select plugin (https://silviomoreto.github.io/bootstrap-select/) -->
    <link href="/bootstrap-select/css/bootstrap-select.min.css" rel="stylesheet" >
    <!-- Bootstrap switch plugin (https://github.com/nostalgiaz/bootstrap-switch) -->
    <link href="/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet">
    <!-- Multiselect plugin (http://loudev.com/#home) -->
    <link href="/lou-multi-select/css/multi-select.dist.css" rel="stylesheet">
    <!-- Bootstrap datepicker -->
    <link href="/bootstrap-datepicker/css/bootstrap-datepicker3.min.css" rel="stylesheet">
    <!-- Custom CSS.  Keep this last -->
    <link href="/css/custom.css" rel="stylesheet">
    
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <!--
                <a class="navbar-brand" href="#">
                    <img src="http://placehold.it/150x50&text=Logo" alt="">
                </a>
                -->
                <h1 class="logotext">
                    <a href="/">phpMyAnsibleAdmin</a>
                </h1>
            </div>
            {% if is_logged_in %}
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-top-links navbar-right">
                    <li class="dropdown user_menu">
                        <a class="dropdown-toggle user_menu" data-toggle="dropdown" href="#">
                            {{ user_display_name }}&nbsp;
                            <i class="fa fa-user fa-fw"></i><i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">
                            <li><a href="/profile">
                                <i class="fa fa-user fa-fw"></i> User Profile</a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <a href="/logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                            </li>
                        </ul>
                    </li>
                </ul>
                <ul class="nav navbar-nav pull-right navbar_left" style="margin-right: 30px;">
                    {% if tasks_on %}
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Tasks&nbsp;<i class="fa fa-caret-down"></i></a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="/tasks/submit"><i class="fa fa-plus-circle fa-fw menu-icon"></i>Submit new task</a>
                            </li>
                            <li>
                                <a href="/tasks"><i class="fa fa-tasks fa-fw menu-icon"></i>Task log</a>
                            </li>
                            <li>
                                <a href="/tasks/preconfiguredTasks"><i class="fa fa-cogs fa-fw menu-icon"></i>Preconfigured tasks</a>
                            </li>
                        </ul>
                    </li>
                    {% endif %}
                    <li>
                        <a href="/servers">Servers</a>
                    </li>
                    <li>
                        <a href="/groups">Groups</a>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Admin&nbsp;<i class="fa fa-caret-down"></i></a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="/admin/users"><i class="fa fa-users fa-fw menu-icon"></i>Manage Users</a>
                            </li>
                            <li>
                                <a href="/admin/cleanup"><i class="fa fa-history fa-fw menu-icon"></i>Cleanup Task History</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            {% endif %}
        </div>
    </nav>
    <div class="container">
        {% block content %}{% endblock %}
    </div>
    <footer class="sticky">
        <div class="container">
            <p class="text-right">Powered by <a href="https://github.com/kissit/phpMyAnsibleAdmin">phpMyAnsibleInventory</a></p>
        </div>
    </footer>
</body>
<!-- jQuery -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<!-- Bootstrap JS -->
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- Datatables JS - NOTE: 1.10.8 is used specifically for a fix for removing table rows that has been re-introduced in later versions -->
<!-- See this for more info: https://github.com/DataTables/DataTables/issues/566 -->
<script src="//cdn.datatables.net/1.10.8/js/jquery.dataTables.min.js"></script>
<script src="//cdn.datatables.net/1.10.8/js/dataTables.bootstrap.min.js"></script>
<!-- Bootstrap growl (https://github.com/ifightcrime/bootstrap-growl) -->
<script src="/js/jquery.bootstrap-growl.min.js"></script>
<!-- Jqueryvalidation plugin (https://jqueryvalidation.org/) -->
<script src="/jquery-validation/jquery.validate.min.js"></script>
<!-- Selectpicker plugin (https://silviomoreto.github.io/bootstrap-select/) -->
<script src="/bootstrap-select/js/bootstrap-select.min.js"></script>
<!-- Bootstrap switch plugin (https://github.com/nostalgiaz/bootstrap-switch) -->
<script src="/bootstrap-switch/js/bootstrap-switch.min.js"></script>
<!-- Bootstrap confirmation plugin (http://bootstrap-confirmation.js.org/) -->
<script src="/bootstrap-confirmation/bootstrap-confirmation.min.js"></script>
<!-- Multiselect plugin (http://loudev.com/#home) -->
<script src="/lou-multi-select/js/jquery.multi-select.js"></script>
<!-- Slimscroll plugin (http://rocha.la/jQuery-slimScroll) -->
<script src="/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<!-- BlockUI plugin (http://malsup.com/jquery/block/) -->
<script src="/js/jquery.blockUI.js"></script>
<!-- Bootstrap datepicker -->
<script src="/bootstrap-datepicker/js/bootstrap-datepicker.min.js"></script>
<!-- Custom JS -->
<script src="/js/jquery.validate.defaults.js"></script>
<script src="/js/utility.js"></script>

<!-- Used for passing a user message from the server -->
<input type="hidden" id="flash_message" value="{{ flash_message }}">
<input type="hidden" id="flash_status" value="{{ flash_status }}">

{% block pagejs %}{% endblock %}
</html>

