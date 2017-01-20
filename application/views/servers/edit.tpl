{% extends "wrapper.tpl" %}
{% block content %}
{% include "servers/page_heading.tpl" %}
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
               <b>{{ server.id > 0 ? 'Edit' : 'Add' }} Server</b>
            </div>
            <div class="panel-body">
                
            </div>
        </div>
    </div>
</div>
{% endblock %}
{% block pagejs %}
<script>
$(document).ready(function() {
    
});
</script>
{% endblock %}