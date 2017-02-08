{% extends "wrapper.tpl" %}
{% block content %}
{% include "tasks/page_heading.tpl" %}
<div class="alert alert-info">
    <div class="row">
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="control-label">Final command: </label>
                {{ task.command }}
            </div>
            <div class="form-group">
                <label class="control-label">Selected command: </label>
                {{ task.command_name | default('None') }}
            </div>
            <div class="form-group">
                <label class="control-label">Limit: </label>
                {{ task.command_limit | default('None') }}
            </div>
            <div class="form-group">
                <label class="control-label">Tags: </label>
                {{ task.command_tags | default('None') }}
            </div>
            <div class="form-group">
                <label class="control-label">Notes: </label>
                {{ task.notes | default('None') }}
            </div>
        </div>
        <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="control-label">Status: </label>
                {{ task.status }}
            </div>
            <div class="form-group">
                <label class="control-label">Submitted by: </label>
                {{ task.owner.first_name }} {{ task.owner.last_name }}
            </div>
            <div class="form-group">
                <label class="control-label">Submitted Date/Time: </label>
                {{ task.created_date | default('None') }}
            </div>
            <div class="form-group">
                <label class="control-label">Start Date/Time: </label>
                {{ task.start_date }}
            </div>
            <div class="form-group">
                <label class="control-label">End Date/Time </label>
                {{ task.end_date }}
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Task Log
                    <div class="pull-right">
                        <div class="label label-default" id="task_status">{{ task.status | capitalize }}</div>&nbsp;&nbsp;
                        <button class="btn btn-success btn-xs" id="refresh"><i class="fa fa-refresh"></i></button>
                        
                    </div>
                </h3>
            </div>
            <div class="panel-body" id="refresh_block">
                <div id="log_view"><pre id="log_data">{{ log_data | default('No log data') }}</pre></div>
            </div>
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
function updateStatus(status) {
    $("#task_status").removeClass();
    if(status == 'queued') {
        $("#task_status").addClass("label label-default");
        $("#cancel_task").css('display', '');
    } else if (status == 'cancelled') {
        $("#task_status").addClass("label label-warning");
        $("#cancel_task").css('display', 'none');
    } else if (status == 'error') {
        $("#task_status").addClass("label label-danger");
        $("#cancel_task").css('display', 'none');
    } else {
        $("#task_status").addClass("label label-success");
        $("#cancel_task").css('display', 'none');
    }
    $("#task_status").html(capitalizeStr(status));
}
$(document).ready(function() {
    updateStatus('{{ task.status }}');
    $("#log_view").slimScroll({
        size: '8px',
        color: '#286090',
        railVisible: true,
        railColor: '#286090',
        railOpacity: 0.2,
        allowPageScroll: false,
        disableFadeOut: false,
        start: 'bottom',
        height: '500px',
    });
    $("#refresh").click(function() {
        blockElement("refresh_block");
        $.get("/tasks/check/{{ task.id }}", function(resp) {
            if(resp.hasOwnProperty('task')) {
                updateStatus(resp.task.status);
            }
            if(resp.hasOwnProperty('log_data')) {
                $("#log_data").html(resp.log_data);
                $("#log_view").slimScroll({scrollTo: $("#log_data").height() + 'px'});
            }
            unblockElement("refresh_block");
        });
    });
    $("#cancel_task").confirmation({
        placement: 'bottom',
        container: 'body',
        title: "Are you sure you want to cancel this task?",
        onConfirm: function(e) {
            window.location="/tasks/cancel/{{ task.id }}";
        },
    });
});
</script>
{% endblock %}