{% extends "wrapper.tpl" %}
{% block content %}
{% include "servers/page_heading.tpl" %}
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
               <b>Server List</b>
            </div>
            <div class="panel-body">
                <div class="dataTable_wrapper table-responsive container-fluid" id="datatable_wrapper">
                    <table class="table table-striped table-bordered table-hover" id="datatable1">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Private IP</th>
                                <th>Public IP</th>
                                <th>App</th>
                                <th>Region</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {% for row in rows %}
                            <tr>
                                <td>{{ row.server_name }}</td>
                                <td>{{ row.private_ip }}</td>
                                <td>{{ row.public_ip }}</td>
                                <td>{{ row.app }}</td>
                                <td>{{ row.region }}</td>
                                <td class="text-center"><label class="label label-{{ row.status == 1 ? 'success' : 'danger' }}">{{ row.status == 1 ? 'Enabled' : 'Disabled' }}</label></td>
                                <td>{{ row.created_date | date("Y-m-d H:i")}}</td>
                                <td>
                                    <a href="/servers/edit/{{ row.id }}" class="btn btn-xs btn-primary ktooltip" ktitle="Edit this server" data-container="body"><i class="fa fa-pencil"></i></a>
                                    {% if row.status == 1 %}
                                    <button class="btn btn-xs btn-danger ktooltip" ktitle="Disable this server" data-container="body"><i class="fa fa-pause"></i></button>
                                    {% else %}
                                    <button class="btn btn-xs btn-success ktooltip" ktitle="Enable this server" data-container="body"><i class="fa fa-play"></i></button>
                                    {% endif %}
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
        "pageLength": 50,
        "stateSave": true,
        "columnDefs": [
            {"targets": -1, "orderable": false, "searchable": false, "width": "70px", "className": "text-center"}
        ],
    });
});
</script>
{% endblock %}
