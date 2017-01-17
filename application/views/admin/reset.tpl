{% extends "admin/login_wrapper.tpl" %}
{% block content %}
<div class="row">
    <div class="col-md-4 col-md-offset-4">
        <div class="login-panel panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Reset Password</h3>
            </div>
            <div class="panel-body">
                {% if message|default %}
                <div class="alert alert-danger alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    {{ message|raw }}
                </div>
                {% endif %}
                <form role="form" method="POST" action="/admin/login/doReset">
                    <fieldset>
                        <div class="form-group">
                            <label>Enter your email to reset password</label>
                            <input class="form-control" placeholder="E-mail" name="email" type="email" autofocus data-validation="email" data-validation-error-msg="You must provide a valid email">
                        </div>
                        <button class="btn btn-lg btn-success btn-block">Reset</button>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    $.validate({
        onError : function() {
            return false;
        }
    });
});
</script>
{% endblock %}