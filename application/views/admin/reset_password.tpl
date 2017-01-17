{% extends "admin/login_wrapper.tpl" %}
{% block content %}
<div class="row">
    <div class="col-md-4 col-md-offset-4">
        <div class="login-panel panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Password Reset</h3>
            </div>
            <div class="panel-body">
                {% if message|default %}
                <div class="alert {{ message_type ? message_type : 'alert-danger' }} alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    {{ message|raw }}
                </div>
                {% endif %}
                <form role="form" method="POST" action="/admin/login/doResetPassword">
                    <input type="hidden" name="user_id" value="{{ user_id }}">
                    <input type="hidden" name="code" value="{{ code }}">
                    <input type="hidden" name="{{ csrf.key }}" value="{{ csrf.value }}">
                    <div class="form-group">
                        <label>Password (Between {{ min_password_length }} and {{ max_password_length }} characters)</label>
                        <input class="form-control" placeholder="Password" name="pass_confirmation" type="password" data-validation="length" data-validation-length="{{ min_password_length }}-{{ max_password_length }}" value="">
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input class="form-control" placeholder="Confirm Password" name="pass" type="password" data-validation="confirmation" data-validation-error-msg="Passwords do not match, please retry." value="">
                    </div>
                    <button class="btn btn-lg btn-success btn-block">Reset</button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    $.validate({
        modules : 'security',
        onError : function() {
            return false;
        }
    });
});
</script>
{% endblock %}