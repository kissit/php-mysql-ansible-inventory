{% extends "wrapper.tpl" %}
{% block content %}
{% include "servers/page_heading.tpl" %}
<form id="form1" method="post" action="/servers/update">
<input type="hidden" name="id" value="{{ row.id | default(0) }}">
<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="form-group">
            <label class="control-label">Server Name</label>
            <input type="text" class="form-control" name="post[server_name]" value="{{ row.server_name }}">
        </div>
        <div class="form-group">
            <label class="control-label">External Server ID</label>
            <input type="text" class="form-control" name="post[external_server_id]" value="{{ row.external_server_id }}">
        </div>
        <div class="form-group">
            <label class="control-label">Public IP</label>
            <input type="text" class="form-control" name="post[public_ip]" value="{{ row.public_ip }}">
        </div>
        <div class="form-group">
            <label class="control-label">Private IP</label>
            <input type="text" class="form-control" name="post[private_ip]" value="{{ row.private_ip }}">
        </div>
    </div>
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="form-group">
            <label class="control-label">App</label>
            <input type="text" class="form-control" name="post[app]" value="{{ row.app }}">
        </div>
        <div class="form-group">
            <label class="control-label">Region</label>
            <input type="text" class="form-control" name="post[region]" value="{{ row.region }}">
        </div>
        <div class="form-group">
            <label class="control-label">Ansible Host Groups</label>
            <select class="form-control selectpicker" data-container="body" data-live-search="true" name="groups[]" multiple>
                {% for opt in groups_options %}
                {{ opt | raw }}
                {% endfor %}
            </select>
        </div>
        <div class="form-group">
            <label class="control-label">Monitoring Groups</label>
            <select class="form-control selectpicker" data-container="body" data-live-search="true" name="monitor_groups[]" multiple>
                {% for opt in monitor_groups_options %}
                {{ opt | raw }}
                {% endfor %}
            </select>
        </div>
        
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <button type="submit" class="btn btn-primary"><i class="fa fa-floppy-o"></i>&nbsp;&nbsp;Save&nbsp;</button>&nbsp;
        <button type="submit" class="btn btn-primary" name="save_add"><i class="fa fa-floppy-o"></i>&nbsp;&nbsp;Save & Add Another&nbsp;</button>&nbsp;
        <a class="btn btn-default" href="/servers"><i class="fa fa-backward"></i>&nbsp;&nbsp;Cancel&nbsp;</a>
    </div>
</form>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $("#form1").validate({
        rules: {
            "post[server_name]": {
                required: true,
            },
        }
    });
});
</script>
{% endblock %}