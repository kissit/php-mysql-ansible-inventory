{% extends "wrapper.tpl" %}
{% block content %}
<br>
<div class="row">
    <div class="col-md-6">
        <form method="post" action="/admin/processCleanup">
            <div class="form-group">
                <label class="control-label">Select a date to purge the task history to</label>
                <div class="input-group date" style="width: 150px;" data-provide="datepicker" data-date-format="yyyy-mm-dd" data-date-autoclose="true">
                    <input class="form-control" type="text" name="purge_date">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-th"></span>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
{% endblock %}
