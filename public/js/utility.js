function displayMessage(message, status, delay, align, offset) {
    if (status === undefined) status = "success";
    if (delay === undefined) delay = 3000;
    if (align === undefined) align = 'right';
    if (offset === undefined) offset = {from: 'top', amount: 20};
    $.bootstrapGrowl(message, {
        ele: 'body',
        type: status,
        offset: offset,
        align: align,
        width: 250,
        delay: delay,
        allow_dismiss: true
    });
}
function displayDefaultError() {
    displayMessage("Something went wrong while processing your request", "danger");
}
function blockui(msg) {
    if (msg === undefined) msg = "Processing...please wait";
    $.blockUI({
        message: '<h4><i class="fa fa-spinner fa-pulse fa-1x fa-fw"></i>&nbsp; '+msg+'</h4>',
        css: { border: '2px solid #31708f', backgroundColor: "#d9edf7", color: "#31708f"}
    });
}
function unblockui() {
    $.unblockUI();
}
$(document).ready(function(){
    var message = $("#flash_message").val();
    if(message.length > 0) {
        var status = $("#flash_status").val();
        displayMessage(message, status);
    }

    // Sitewide tooltip class handler
    $(document).tooltip({
        selector: '.ktooltip',
        html: true,
        title: function() {
            return $(this).attr('ktitle');
        }
    });
});