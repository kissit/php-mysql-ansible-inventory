{% block content %}
<div class="modal fade" id="kiss_modal" tabindex="-1" role="dialog" aria-labelledby="kiss_modal_label" aria-hidden="true" data-backdrop="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="kiss_modal_label">{{ modal_title }}</h4>
            </div>
            <div class="modal-body" id="modal_body"></div>
            <div class="modal-footer">
                <input type="hidden" id="kiss_modal_confirm_type" value="">
                <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="kiss_modal_confirm">Yes</button>
            </div>
        </div>
    </div>
</div>
{% endblock %}