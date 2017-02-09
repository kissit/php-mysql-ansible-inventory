{% extends "wrapper.tpl" %}
{% block content %}
{% include "servers/page_heading.tpl" %}
<form id="form1" method="post" action="/tasks/setPreconfiguredTask">
<input type="hidden" name="id" value="{{ row.id | default(0) }}">
<div class="row">
    <div class="col-md-8 col-sm-12 col-xs-12">
        <div class="form-group">
            <label class="control-label">Task Name</label>
            <input type="text" class="form-control" name="post[name]" value="{{ row.name }}">
        </div>
        <div class="form-group">
            <label class="control-label">Command</label>
            <input type="text" class="form-control" name="post[command]" value="{{ row.command }}">
        </div>
        <div class="form-group">
            <label class="control-label">Description</label>
            <textarea class="form-control" name="post[description]" rows="5">{{ row.description }}</textarea>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <button type="submit" class="btn btn-primary"><i class="fa fa-floppy-o"></i>&nbsp;&nbsp;Save&nbsp;</button>&nbsp;
        <a class="btn btn-default" href="/tasks/preconfiguredTasks"><i class="fa fa-backward"></i>&nbsp;&nbsp;Cancel&nbsp;</a>
    </div>
</div>
</form>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    $("#form1").validate({
        rules: {
            "post[name]": {required: true},
            "post[command]": {required: true},
        }
    });
});
</script>
{% endblock %}