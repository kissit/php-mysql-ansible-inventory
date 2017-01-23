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
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
               <b>User List</b>
            </div>
            <div class="panel-body">
                <div class="dataTable_wrapper table-responsive container-fluid">
                    <table class="table table-striped table-bordered table-hover" id="datatable1">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Name</th>
                                <th>Last Login</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        {%for row in rows %}
                            {% if row.active == 1 %}
                                {% set active_icon_class = 'fa-check-circle' %}
                                {% set active = 'Active' %}
                            {% else %}
                                {% set active_icon_class = 'fa-times-circle' %}
                                {% set active = 'Inactive' %}
                            {% endif %}
                            <tr>
                                <td><a href="/admin/editUser/{{ row.id }}">{{ row.email }}</a></td>
                                <td>{{ row.first_name }} {{ row.last_name }}</td>
                                <td>{{ row.last_login|date("Y-m-d H:i:s") }}</td>
                                <td align="center">
                                    <span class="label label-{{ row.active == 1 ? 'success' : 'danger'}}">{{ row.active == 1 ? 'Enabled' : 'Disabled'}}</span>
                                </td>
                            </tr>
                        {% endfor %}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $('#datatable1').DataTable({
        "responsive": true,
        "pageLength": 25,
        "stateSave": true,
    });
});
</script>
{% endblock %}