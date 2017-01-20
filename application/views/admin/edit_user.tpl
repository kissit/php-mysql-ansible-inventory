{% extends "wrapper.tpl" %}
{% block content %}
<div class="row" style="margin-bottom: 20px;">
    <div class="col-md-12">
        <div class="pull-right">
            <a class="btn btn-primary" href="/admin/editUser"><i class="fa fa-plus-circle"></i>&nbsp;&nbsp;Add New User</a>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="panel panel-default">
            <div class="panel-heading">
                {% if user.id > 0 %}
                <b>Update User Profile</b>
                {% else %}
                <b>Add New User</b>
                {% endif %}
            </div>
            <div class="panel-body">
                <form id="edit_user" method="POST" action="/admin/processEditUser">
                    <input type="hidden" name="id" value="{{ user.id | default('0') }}">
                    <input type="hidden" id="old_email" value="{{ user.email }}">
                    <div class="form-group">
                        <label>Email Address</label>
                        <input class="form-control" id="email" name="user[email]" type="text" value="{{ user.email }}">
                    </div>
                    <div class="form-group">
                        <label>First Name</label>
                        <input class="form-control" name="user[first_name]" type="text" value="{{ user.first_name }}">
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <input class="form-control" name="user[last_name]" type="text" value="{{ user.last_name }}">
                    </div>
                    {% if user.id > 0 %}
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control selectpicker" name="active">
                            {% for option in status_options %}
                            {{ option|raw }}
                            {% endfor %}
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Password (Between {{ min_password_length }} and {{ max_password_length }} characters)</label>
                        <input class="form-control" id="password1" name="password1" type="password" value="">
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input class="form-control" id="password2" name="password2" type="password" value="">
                    </div>
                    {% endif %}
                    <button class="btn btn-primary" type="submit">Save</button>&nbsp;<a class="btn btn-default" href="/admin/users">Cancel</a>
                    {% if user.id > 0 %}
                    <button id="delete_user" class="btn btn-danger" type="button">Delete</button>
                    {% endif %}
                </form>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="alert alert-info" role="alert">
            When adding a new user we will send a confirmation email to their address.  The user can then activate their account and set their password.  You can only specify a password when editing an existing user.  Leave the password blank unless you wish to change it.
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $("#edit_user").validate({
        rules: {
            "user[email]": {
                required: true,
                email: true,
                remote: {
                    url: "/login/checkRegEmail",
                    type: "post",
                    async: false,
                    data: {
                        email: function() { return $("#email").val(); },
                        email_old: function() { return $("#old_email").val(); },
                    }
                }
            },
            "user[first_name]": {
                required: true,
            },
            "user[last_name]": {
                required: true,
            },
            "password1": {
                required: false,
                minlength: {{ min_password_length | default(8) }},
                maxlength: {{ max_password_length | default(32) }}
            },
            "password2": {
                equalTo: "#password1",
            },
        }
    });
    {% if user.id > 0 %}
    $("#delete_user").click(function(event){
        $("#modal_body").html("Are you sure you want to delete this user?");
        $('#kiss_modal').modal('show');
    });
    $("#kiss_modal_confirm").click(function(event){
        $("#delete_user_form").submit();
    });
    {% endif %}
});
</script>
{% endblock %}