{% extends "wrapper.tpl" %}
{% block content %}
{% include "tasks/page_heading.tpl" %}
<div class="row">
    <div class="col-md-12">
        <div class="dataTable_wrapper table-responsive container-fluid">
            <table class="table table-striped table-bordered table-hover" id="datatable1">
                <thead>
                    <tr>
                        <th>Date/Time</th>
                        <th>Owner</th>
                        <th>Status</th>
                        <th>Command</th>
                        <th>Notes</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in rows %}
                    <tr>
                        <td>{{ row.created_date }}</td>
                        <td>{{ row.owner.first_name }} {{ row.owner.last_name }}</td>
                        <td>{{ row.status }}</td>
                        <td>{{ row.command }}</td>
                        <td>{{ row.notes }}</td>
                        <td>
                            <a href="/tasks/view/{{ row.id }}" class="btn btn-xs btn-info ktooltip" ktitle="View details" data-container="body"><i class="fa fa-info-circle"></i></a>
                            {% if row.status == 'queued' %}
                            <a class="btn btn-xs btn-danger ktooltip confirm" ktitle="Cancel this task" href="/tasks/cancel/{{ row.id }}" data-container="body"><i class="fa fa-trash"></i></a>
                            {% elseif row.status == 'complete' or row.status == 'cancelled' %}
                            <button class="btn btn-xs btn-warning ktooltip confirm" ktitle="Run this task again" href="/tasks/reRun/{{ row.id }}" data-container="body"><i class="fa fa-repeat"></i></button>
                            {% endif %}
                        </td>
                    </tr>
                    {% endfor %}
                </tbody>
            </table>
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
        "order": [[ 0, "desc" ]],
        "columnDefs": [
            {"targets": -1, "orderable": false, "searchable": false, "width": "70px", "className": "text-left"}
        ],
    });
    $("#datatable1").confirmation({
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        rootSelector: "#datatable1",
        selector: '.confirm',
        title: function() {
            return "Are you sure you want to " + $(this).attr('ktitle').toLowerCase() + "?";
        }
    });
});
</script>
{% endblock %}