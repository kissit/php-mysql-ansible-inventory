{% extends "wrapper.tpl" %}
{% block content %}
<div class="row" style="margin-top: 40px;">
    <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Reset your password</h3>
            </div>
            <div class="panel-body text-center">
                <form id="reset_form" autocomplete="off" method="POST" action="/login/doReset">
                    <input type="hidden" name="user_id" value="{{ user_id }}">
                    <input type="hidden" name="code" value="{{ code }}">
                    <input type="hidden" name="{{ csrf.key }}" value="{{ csrf.value }}">
                    <div class="form-group">
                        <input class="form-control" type="password" placeholder="Password ({{ min_password_length }}-{{ max_password_length }} characters)" id="password" name="password" type="password" value="" required minlength="{{ min_password_length }}" maxlength="{{ max_password_length }}" >
                    </div>
                    <div class="form-group">
                        <input class="form-control" type="password" placeholder="Confirm Password" name="password2" type="password">
                    </div>
                    <div class="form-actions text-center">
                        <button id="reset_button" class="btn btn-warning">Reset</button>
                        <a class="btn btn-default" href="/">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $("#reset_form").validate({
        onkeyup: false,
        rules: {
            password: {
                required: true,
                minlength: {{ min_password_length | default(8) }},
                maxlength: {{ max_password_length | default(32) }}
            },
            password2: {
                required: true,
                equalTo: "#password"
            },
        },
        messages: {
            password2: {
                required: "You must provide a password between {{ min_password_length }} and {{ max_password_length }} characters",
                equalTo: "Passwords do not match",
            },
        }
    });
});
</script>
{% endblock %}