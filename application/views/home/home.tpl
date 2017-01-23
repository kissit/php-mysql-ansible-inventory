{% extends "wrapper.tpl" %}
{% block content %}
{% if not is_logged_in %}
<div class="row" style="margin-top: 40px;">
    <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Login</h3>
            </div>
            <div class="panel-body">
                <form id="login_form">
                    <div class="form-group">
                        <div class="input-group">
                            <input class="form-control" type="text" autocomplete="off" placeholder="Email" name="email">
                            <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input class="form-control" type="password" autocomplete="off" placeholder="Password" name="password">
                            <span class="input-group-addon"><i class="fa fa-key"></i></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="rememberme check"><input type="checkbox" name="remember" value="1">Remember Me</label>
                    </div>
                    <div class="form-actions text-center">
                        <a class="btn btn-success" id="login_button"><i class="fa fa-sign-in"></i>&nbsp;Login</a>
                        <a class="btn btn-warning" href="/recover"><i class="fa fa-key"></i>&nbsp;Forgot Password?</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
{% else %}
<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <h2>Welcome to phpMyAnsibleAdmin</h2>
        <p>
            Use this tool in combination with our Ansible inventory script to store and manage your ansible inventory.  After using both the Rackspace (rax.py) and AWS EC2 (ec2.py) inventory scripts to manage environments spanning both platforms, it was decided to build an inventory script that relied on the inventory data being stored in a simple MySQL database.  A few advantages this approach has over the individual scripts:
            <br><br>
            <strong>Note, at the current time the tool only is used to manage inventory.  However we plan on adding the ability to run ansible tasks directly from the web interface.</strong>
            <ul>
                <li>Web based.  We've provided this web based utility to manage your inventory</li>
                <li>Speed.  The API based solutions are slow, especially for large inventories.  Our script only requires a few queries.</li>
                <li>Stability.  Our solution only requires that your database is up.  No longer are we stuck when Rackspace's API is not working properly</li>
                <li>Consistency.  Our solution provides a consistent inventory formatting across any kind of platform.</li>
                <li>Simpler.  The other inventory scipts provide a ton of information, most of which we never used.  Our solution includes the most basic information.</li>
                <li>Both ansible groups and monitoring groups.  We use the same inventory to dynamically build Nagios configurations for large environments using the monitoring groups.  No longer miss a server problem due to someone forgetting to add it to Nagios!</li>
            </ul>
        </p>
    </div>
    <div class="col-md-6 col-sm-6 col-xs-12">
        <h2>Getting started</h2>
        <p>
            To get started managing your ansible inventory via phpMyAnsibleAdmin:
            <ul>
                <li>Congrats...since you are here, you already have the application setup and working.</li>
                <li>Install our invetory script (scripts/mysql.php) in your Ansible inventory directory or point to it when running commands.  Modify the database options at the top to match your environment</li>
                <li><a href="/servers">Add some servers</a></li>
                <li><a href="/groups">Add some groups</a> corresponding to your ansible groups/roles and relate servers to them</li>
                <li>Use the usual way of specifying roles, limiting inventory, etc inside Ansible</li>
            </ul>
        </p>
        <h2>Planned features</h2>
        <p>
            We plan on continuing to develop this application, possibly adding some or all of the following:
            <ul>
                <li>Ability to run Ansible tasks directly from the web interface</li>
                <li>Ansible task history</li>
                <li>Notifications</li>
                <li>Cloud integrations to automatically look up server information when not being automatically added by existing automation processes.</li>
            </ul>
        </p>
    </div>
</div>
{% endif %}
{% endblock %}
{% block pagejs %}
{% if not is_logged_in %}
<script>
$(document).ready(function() {
    $("#login_form").validate({
        errorElement: 'span',
        errorClass: 'help-block',
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        success: function(label, element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        rules: {
            email: {
                email: true,
                required: true
            },
            password: {
                required: true
            },
        },
        errorPlacement: function(error, element) {
            return true;
        }
    });
    $("#login_button").click(function() {
        if($("#login_form").valid()) {
            $.post("/login/login", $("#login_form").serialize(), function(response) {
                if(response.hasOwnProperty('redir')) {
                    window.location = response.redir;
                } else if (response.hasOwnProperty('message')) {
                    displayMessage(response.message, 'danger');
                } else {
                    displayDefaultError();
                }
            });
        }
    });
    $("#login_form input").keypress(function(e) {
        if (e.which == 13) {
            $("#login_button").click();
            return false;
        }
    });
});
</script>
{% else %}
<script>
$(document).ready(function() {

});
</script>
{% endif %}
{% endblock %}