{% block page_heading %}
<div class="row" style="margin-bottom: 20px;">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <h3 class="page_title">{{ page_title }}</h3>
    </div>
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="pull-right">
            {% if task.id > 0 and task.status == 'queued' %}
            <button class="btn btn-danger" task_id="{{ task.id }}" id="cancel_task"><i class="fa fa-trash"></i>&nbsp;&nbsp;Cancel Task</button>
            {% endif %}
            {% if not hide_submit %}
            <a class="btn btn-primary" href="/tasks/submit"><i class="fa fa-plus-circle"></i>&nbsp;&nbsp;Submit Task</a>&nbsp;
            {% endif %}
            <a class="btn btn-primary" href="/tasks/editPreconfiguredTask"><i class="fa fa-plus-circle"></i>&nbsp;&nbsp;Add Preconfigured Task</a>
        </div>
    </div>
</div>
{% endblock %}
