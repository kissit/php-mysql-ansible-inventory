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
    <div class="col-md-12">
        Logged in home page
        
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