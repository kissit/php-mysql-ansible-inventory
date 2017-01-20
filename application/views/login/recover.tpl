{% extends "wrapper.tpl" %}
{% block content %}
<style>
.has-error input {
    border: 2px solid #E08283 !important;
}
</style>
<div class="row" style="margin-top: 40px;">
    <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Password Recovery</h3>
            </div>
            <div class="panel-body">
                <form id="recover_form" autocomplete="off" method="POST" action="/login/doRecover">
                    <p>Enter your email address below to recover your password.  We will send you an email with further instructions.</p>
                    <div class="form-group">
                        <div class="input-group">
                            <input class="form-control" type="text" id="email" autocomplete="off" placeholder="Email (required)" name="email" title="Email address is required">
                            <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                        </div>
                    </div>
                </form>
                <div class="form-actions text-center">
                    <button id="recover_button" class="btn btn-warning sbold">Recover</button>
                    <a class="btn btn-default" href="/">Cancel</a>
                </div>
            </div>
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $('#recover_form').validate({
        errorElement: 'span',
        errorClass: 'help-block text-left',
        onkeyup: false,
        ignore: "",
        rules: {
            "email": {
                required: true,
                email: true,
            }
        }
    });
    $("#recover_button").click(function() {
        if($("#recover_form").valid()) {
            $("#recover_form").submit();
        }
    });
});
</script>
{% endblock %}