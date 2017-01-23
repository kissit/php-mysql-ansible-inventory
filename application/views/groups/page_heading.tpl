{% block page_heading %}
<div class="row" style="margin-bottom: 20px;">
    <div class="col-md-6 col-sm-6 col-xs-12">
        <h3 class="page_title">{{ page_title }}</h3>
    </div>
    <div class="col-md-6 col-sm-6 col-xs-12">
        <div class="pull-right">
            <div class="btn-group">
                <button type="button" class="btn btn-primary"><i class="fa fa-plus-circle"></i>&nbsp;&nbsp;Add new...</button>
                <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                    <i class="fa fa-angle-down"></i>
                </button>
                <ul class="dropdown-menu" role="menu">
                    <li>
                        <a class="add_group" group_type="groups" href="#">Ansible group</a>
                    </li>
                    <li>
                        <a class="add_group" group_type="monitor_groups" href="#">Monitoring group</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
{% endblock %}
