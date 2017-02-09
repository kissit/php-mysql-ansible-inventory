{% extends "wrapper.tpl" %}
{% block content %}
{% include "tasks/page_heading.tpl" %}
<form id="form1" method="post" action="/tasks/doSubmit">
<div class="row" style="margin-bottom: 20px;">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="form-group">
            <label class="control-label">Select a preconfigured task</label>
            <select class="form-control selectpicker display_block" name="preconfigured_task" data-container="body" data-live-search="true" data-width="fit" title="None Selected">
                {% for opt in preconfigured_tasks_options %}
                {{ opt | raw }}
                {% endfor %}
            </select>
        </div>
        <div class="form-group">
            <label class="control-label">Provide limit criteria</label>
            <input class="form-control" type="text" name="preconfigured_task_limit">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle"></i>&nbsp;&nbsp;Submit Task&nbsp;</button>&nbsp;
            <a class="btn btn-default" href="/tasks"><i class="fa fa-backward"></i>&nbsp;&nbsp;Cancel&nbsp;</a>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
        <div class="well well-sm well-info text-center">
            <strong> - OR -</strong>
        </div>
    </div>
</div>
<div class="row" style="margin-bottom: 20px;">
    <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="form-group">
            <label class="control-label">Enter a raw ansible command</label>
            <input class="form-control" type="text" name="raw_command">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle"></i>&nbsp;&nbsp;Submit Task&nbsp;</button>&nbsp;
            <a class="btn btn-default" href="/tasks"><i class="fa fa-backward"></i>&nbsp;&nbsp;Cancel&nbsp;</a>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
        <div class="well well-sm well-info text-center">
            <strong> - OR -</strong>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="form-group">
            <label class="control-label">Select a command</label>
            <div class="clearfix">
            <div class="btn-group " data-toggle="buttons">
                <label class="btn btn-default"><input type="radio" class="toggle" name="post[command_name]" value="ansible-playbook"> ansible-playbook </label>
                <label class="btn btn-default"><input type="radio" class="toggle" name="post[command_name]" value="ansible"> ansible </label>
            </div>
            </div>
        </div>
        <div class="form-group">
            <label class="control-label">Enter a playbook</label>
            <input class="form-control" type="text" name="post[playbook]">
        </div>
        <div class="form-group">
            <label class="control-label">Provide limit criteria</label>
            <input class="form-control" type="text" name="post[command_limit]">
        </div>
        <div class="form-group">
            <label class="control-label">Provide a list of tags</label>
            <input class="form-control" type="text" name="post[command_tags]">
        </div>
        <div class="form-group">
            <label class="control-label">Extra options</label>
            <input class="form-control" type="text" name="post[command_options]">
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary"><i class="fa fa-check-circle"></i>&nbsp;&nbsp;Submit Task&nbsp;</button>&nbsp;
            <a class="btn btn-default" href="/tasks"><i class="fa fa-backward"></i>&nbsp;&nbsp;Cancel&nbsp;</a>
        </div>
    </div>
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="form-group">
            <label class="control-label">Notes</label>
            <textarea class="form-control" name="post[notes]" rows="5"></textarea>
        </div>
    </div>
</div>
</form>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {

});
</script>
{% endblock %}