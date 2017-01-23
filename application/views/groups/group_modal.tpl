{% block group_modal %}
<div class="modal fade" id="group_modal" tabindex="-1" role="dialog" aria-labelledby="group_modal_label" aria-hidden="true" data-backdrop="false">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="group_modal_title"></h4>
            </div>
            <div class="modal-body" id="modal_body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="group_modal_save"> Save </button>
                <button type="button" class="btn btn-default" data-dismiss="modal"> Cancel </button>
            </div>
        </div>
    </div>
</div>
<script>
function showGroupModal(id, type) {
    $("#modal_body").html('');
    $.get("/groups/getGroupForm/"+id+"/"+type, function(form_markup) {
        if(form_markup) {
            var title = "";
            if(type == 'groups') {
                title = ((id > 0) ? 'Edit' : 'Add new') + ' ansible group';
            } else if(type == 'monitor_groups') {
                title = ((id > 0) ? 'Edit' : 'Add new') + ' monitoring group';
            }
            $("#group_modal_title").html(title);
            $("#modal_body").html(form_markup);
            $('#group_modal').modal('show');
            $('#servers_multiselect').multiSelect();
        }
    });
}
$(document).ready(function() {
    $("#group_modal_save").click(function() {
        var edit_id = $("#group_id").val();
        $('#group_modal').modal('hide');
        $.post("/groups/update", $("#group_modal_form").serialize(), function(resp) {
            if(resp.hasOwnProperty('id') && parseInt(resp.id) > 0) {
                resp.type = "groupSaved";
                resp.edit_id = edit_id;
                $.event.trigger(resp);
            } else {
                displayDefaultError();
            }
        });
    });
    $(".add_group").click(function() {
        showGroupModal(0, $(this).attr('group_type'));
    });
});
</script>
{% endblock %}