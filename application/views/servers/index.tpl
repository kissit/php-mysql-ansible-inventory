{% extends "wrapper.tpl" %}
{% block content %}
{% include "servers/page_heading.tpl" %}
<div class="row">
    <div class="col-md-12" id="datatable1_col">
        <div class="dataTable_wrapper table-responsive container-fluid">
            <table class="table table-striped table-bordered table-hover" id="datatable1">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Private IP</th>
                        <th>Public IP</th>
                        <th>App</th>
                        <th>Region</th>
                        <th>Created Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {% for row in rows %}
                    <tr id="server_row_{{ row.id }}">
                        <td>{{ row.server_name }}</td>
                        <td>{{ row.private_ip }}</td>
                        <td>{{ row.public_ip }}</td>
                        <td>{{ row.app }}</td>
                        <td>{{ row.region }}</td>
                        <td class="text-nowrap">{{ row.created_date | date("Y-m-d H:i")}}</td>
                        <td>
                            <a href="/servers/edit/{{ row.id }}" class="btn btn-xs btn-primary ktooltip" ktitle="Edit this server" data-container="body"><i class="fa fa-pencil"></i></a>
                            {% if row.status == 1 %}
                            <button id="toggle_btn_{{ row.id }}" class="btn btn-xs btn-warning ktooltip toggle_status" ktitle="Disable this server" kstatus="{{ row.status }}" kid="{{ row.id }}" data-container="body"><i id="toggle_icon_{{ row.id }}" class="fa fa-pause"></i></button>
                            {% else %}
                            <button id="toggle_btn_{{ row.id }}" class="btn btn-xs btn-success ktooltip toggle_status" ktitle="Enable this server" kstatus="{{ row.status }}"  kid="{{ row.id }}" data-container="body"><i id="toggle_icon_{{ row.id }}" class="fa fa-play"></i></button>
                            {% endif %}
                            <button class="btn btn-xs btn-danger ktooltip delete" ktitle="Delete this server" kid="{{ row.id }}"><i class="fa fa-trash"></i></a>
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
    $("#datatable1_col").confirmation({
        rootSelector: '#datatable1_col',
        selector: '.delete',
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        title: function() {
            return "Are you sure you want to " + $(this).attr('ktitle').toLowerCase() + "?";
        },
        onConfirm: function(e) {
            var elem = $(this);
            var kid = elem.attr('kid');
            $.get("/servers/delete/"+kid, function(response) {
                if(parseInt(response) > 0) {
                    displayMessage("Server deleted");
                    datatable1.row($("#server_row_"+kid)).remove().draw();
                } else {
                    displayDefaultError();
                }
            });
        },
    });
});
</script>
{% endblock %}
