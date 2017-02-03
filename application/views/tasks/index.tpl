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
                            <button class="btn btn-xs btn-danger ktooltip cancel" ktitle="Cancel this task" kid="{{ row.id }}" data-container="body"><i class="fa fa-trash"></i></button>
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
            {"targets": -1, "orderable": false, "searchable": false, "width": "70px", "className": "text-center"}
        ],
    });
    $("#datatable1").confirmation({
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        rootSelector: "#datatable1",
        selector: '.toggle_status',
        title: function() {
            return "Are you sure you want to " + $(this).attr('ktitle').toLowerCase() + "?";
        },
        onConfirm: function(e) {
            var elem = $(this);
            var set_status = inverse(elem.attr('kstatus'));
            var kid = elem.attr('kid');
            $.get("/servers/setStatus/"+kid+"/"+set_status, function(response) {
                if(parseInt(response) > 0) {
                    displayMessage("Server status updated");
                    elem.attr('kstatus', set_status);
                    elem.attr('ktitle', capitalizeStr(getStatusText(set_status)) + " this server");
                    $("#toggle_btn_"+kid).toggleClass("btn-danger");
                    $("#toggle_btn_"+kid).toggleClass("btn-success");
                    $("#toggle_icon_"+kid).toggleClass("fa-pause");
                    $("#toggle_icon_"+kid).toggleClass("fa-play");
                } else {
                    displayDefaultError();
                }
            });
        },
    });
});
</script>
{% endblock %}