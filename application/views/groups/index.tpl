{% extends "wrapper.tpl" %}
{% block content %}
{% include "groups/page_heading.tpl" %}
<div class="row">
    <div class="col-md-6 col-sm-12 col-xs-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <b>Ansible Groups</b>
            </div>
            <div class="panel-body">
                <div class="table-responsive container-fluid">
                    <table class="table table-striped table-bordered table-hover" id="groups_dt">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Server Count</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {% for row in groups_rows %}
                            <tr id="groups_row_{{ row.id }}">
                                <td id="name_{{ row.id }}">{{ row.name }}</td>
                                <td id="count_{{ row.id }}">{{ servers_groups[row.id] | default(0) }}</td>
                                <td>
                                    <button class="btn btn-xs btn-primary ktooltip edit_group" kid="{{ row.id }}" ktitle="Edit this group and member servers" data-container="body"><i class="fa fa-pencil"></i></button>
                                    <button class="btn btn-xs btn-danger ktooltip delete" ktitle="Delete this group" kid="{{ row.id }}" data-container="body"><i class="fa fa-trash"></i></button>
                                </td>
                            </tr>
                            {% endfor %}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-sm-12 col-xs-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <b>Monitoring Groups</b>
            </div>
            <div class="panel-body">
                <div class="dataTable_wrapper table-responsive container-fluid">
                    <table class="table table-striped table-bordered table-hover" id="monitor_groups_dt">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Server Count</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {% for row in monitor_groups_rows %}
                            <tr id="monitor_groups_row_{{ row.id }}">
                                <td id="name_{{ row.id }}">{{ row.name }}</td>
                                <td id="count_{{ row.id }}">{{ servers_monitor_groups[row.id] | default(0) }}</td>
                                <td>
                                    <button class="btn btn-xs btn-primary ktooltip edit_group" kid="{{ row.id }}" ktitle="Edit this group and member servers" data-container="body"><i class="fa fa-pencil"></i></button>
                                    <button class="btn btn-xs btn-danger ktooltip delete" ktitle="Delete this group" kid="{{ row.id }}" data-container="body"><i class="fa fa-trash"></i></button>
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
    // Initialize datatables and the delete confirmations
    var groups_dt = $('#groups_dt').DataTable({
        "responsive": true,
        "pageLength": 10,
        "stateSave": true,
        "columnDefs": [
            {"targets": -1, "orderable": false, "searchable": false, "width": "70px", "className": "text-center"}
        ],
    });
    $("#groups_dt").confirmation({
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        rootSelector: "#groups_dt",
        selector: '.delete',
        title: function() {
            return "Are you sure you want to delete this group?   It will also be removed from all associated servers.";
        },
        onConfirm: function(e) {
            var kid = $(this).attr('kid');
            var type = "groups";
            $.get("/groups/delete/"+type+"/"+kid, function(response) {
                if(parseInt(response) > 0) {
                    displayMessage("Group deleted");
                    groups_dt.row($("#groups_row_"+kid)).remove().draw();
                } else {
                    displayDefaultError();
                }
            });
        },
    });
    var monitor_groups_dt = $('#monitor_groups_dt').DataTable({
        "responsive": true,
        "pageLength": 10,
        "stateSave": true,
        "columnDefs": [
            {"targets": -1, "orderable": false, "searchable": false, "width": "70px", "className": "text-center"}
        ],
    });
    $("#monitor_groups_dt").confirmation({
        placement: 'bottom',
        container: 'body',
        singleton: true,
        popout: true,
        rootSelector: "#monitor_groups_dt",
        selector: '.delete',
        title: function() {
            return "Are you sure you want to delete this group?   It will also be removed from all associated servers.";
        },
        onConfirm: function(e) {
            var kid = $(this).attr('kid');
            var type = "monitor_groups";
            $.get("/groups/delete/"+type+"/"+kid, function(response) {
                if(parseInt(response) > 0) {
                    displayMessage("Group deleted");
                    monitor_groups_dt.row($("#monitor_groups_row_"+kid)).remove().draw();
                } else {
                    displayDefaultError();
                }
            });
        },
    });
    
    // Click handlers for group buttons
    $("#groups_dt").on("click", ".edit_group", function () {
        var id = $(this).attr('kid');
        showGroupModal(id, 'groups');
    });
    $("#monitor_groups_dt").on("click", ".edit_group", function () {
        var id = $(this).attr('kid');
        showGroupModal(id, 'monitor_groups');
    });

    // Callback for edit group modal
    $(document).on("groupSaved", function(e) {
        if(e.edit_id == e.id) {
            if(e.group_type == 'groups') {
                $("#groups_dt #name_"+e.id).html(e.name);
                $("#groups_dt #count_"+e.id).html(e.count);
                groups_dt.draw(false);
            } else if (e.group_type = 'monitor_groups') {
                $("#monitor_groups_dt #name_"+e.id).html(e.name);
                $("#monitor_groups_dt #count_"+e.id).html(e.count);
                monitor_groups_dt.draw(false);
            }
        } else {
            var newrow = $('<tr id="'+e.group_type+'_row_'+e.id+'">')
                .append('<td id="name_'+e.id+'">'+e.name+'</td>')
                .append('<td id="count_'+e.id+'">'+e.count+'</td>')
                .append('<td><button class="btn btn-xs btn-primary ktooltip edit_group" kid="'+e.id+'" ktitle="Edit this group and member servers" data-container="body"><i class="fa fa-pencil"></i></button>&nbsp;<button class="btn btn-xs btn-danger ktooltip delete" ktitle="Delete this group" kid="'+e.id+'" data-container="body"><i class="fa fa-trash"></i></button></td>');

            if(e.group_type == 'groups') {
                groups_dt.row.add(newrow).draw(false);
            } else if (e.type = 'monitor_groups') {
                monitor_groups_dt.row.add(newrow).draw(false);
            }
        }
        displayMessage("Group saved");
    });
});
</script>
{% include "groups/group_modal.tpl" %}
{% endblock %}
