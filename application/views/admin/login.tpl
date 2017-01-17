{% extends "admin/login_wrapper.tpl" %}
{% block content %}
<div class="row">
    <div class="col-md-4 col-md-offset-4">
        <div class="login-panel panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Please Sign In</h3>
            </div>
            <div class="panel-body">
                {% if message|default %}
                <div class="alert {{ message_type ? message_type : 'alert-danger' }} alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    {{ message|raw }}
                </div>
                {% endif %}
                <form role="form" method="POST" action="/admin/login/login">
                    <fieldset>
                        <div class="form-group">
                            <input class="form-control" placeholder="E-mail" name="email" type="email" autofocus>
                        </div>
                        <div class="form-group">
                            <input class="form-control" placeholder="Password" name="password" type="password" value="">
                        </div>
                        <div class="checkbox">
                            <label>
                                <input name="remember" type="checkbox" value="Remember Me">Remember Me
                            </label>
                        </div>
                        <button class="btn btn-lg btn-success btn-block">Login</button>
                    </fieldset>
                </form>
                <br>
                <div style="text-align: center;">
                    <a href="/admin/login/reset">Forgot Password?</a>
                </div>
                <div style="text-align: center;">&nbsp;</div>
                <div style="text-align: center;">
                    <a href="/">Home Page</a>
                </div>
            </div>
        </div>
    </div>
</div>
{% endblock %}