{% extends "wrapper.tpl" %}
{% block content %}
{% include "tasks/page_heading.tpl" %}
<div class="row">
    <div class="col-md-12">
        <div class="dataTable_wrapper table-responsive container-fluid">
            <table class="table table-striped table-bordered table-hover" id="datatable1">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Created Date</th>
                        <th>Created By</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in rows %}
                    <tr id="task_row_{{ row.id }}">
                        <td>{{ row.name }}</td>
                        <td>{{ row.description }}</td>
                        <td>{{ row.created_date }}</td>
                        <td>{{ row.owner.first_name }} {{ row.owner.last_name }}</td>
                        <td>
                            <a href="/tasks/editPreconfiguredTask/{{ row.id }}" class="btn btn-xs btn-primary ktooltip" ktitle="Edit task" data-container="body"><i class="fa fa-edit"></i></a>
                            <button class="btn btn-xs btn-danger ktooltip delete" kid="{{ row.id }}" ktitle="Delete task" data-container="body"><i class="fa fa-trash"></i></button>
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
    var datatable1 = $('#datatable1').DataTable({
        "responsive": true,
        "pageLength": 50,
        "stateSave": true,
        "order": [[ 0, "asc" ]],
        "columnDefs": [
            {"targets": -1, "orderable": false, "searchable": false, "width": "40px", "className": "text-left"}
        ],
    });
    $("#datatable1").confirmation({
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        rootSelector: "#datatable1",
        selector: '.delete',
        title: function() {
            return "Are you sure you want to " + $(this).attr('ktitle').toLowerCase() + "?";
        },
        onConfirm: function(e) {
            var kid = $(this).attr('kid');
            $.get("/tasks/deletePreconfiguredTask/"+kid, function(response) {
                if(parseInt(response) > 0) {
                    displayMessage("Task deleted");
                    datatable1.row($("#task_row_"+kid)).remove().draw(false);
                } else {
                    displayDefaultError();
                }
            });
        },
    });
});
</script>
{% endblock %}