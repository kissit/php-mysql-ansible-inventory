{% block group_form %}
<form id="group_modal_form">
    <input type="hidden" id="group_id" name="id" value="{{ group.id | default(0) }}">
    <input type="hidden" id="group_type" name="group_type" value="{{ group_type }}">
    <div class="form-group">
        <label class="control-label">Name</label>
        <input class="form-control" type="text" id="group_name" name="name" value="{{ group.name }}">
    </div>
    <div class="form-group">
        <label class="control-label">Member Servers</label>
        <select id="servers_multiselect" name="group_servers[]" multiple>
            {% for opt in servers_options %}
            {{ opt | raw }}
            {% endfor %}
        </select>
    </div>
</form>
{% endblock %}
