jQuery(document).ready(function() {
    jQuery.validator.setDefaults({
        errorElement: 'span',
        errorClass: 'help-block',
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        success: function(label, element) {
            if ($(element).closest('.form-group').length === 1) {
                $(element).closest('.form-group').removeClass('has-error');
            } else {
                label.closest('.form-group').removeClass('has-error');
            }
            label.remove();
        },
        errorPlacement: function(error, element) {
            if (element.closest('.input-icon').length === 1) {
                error.insertAfter(element.closest('.input-icon'));
            } else if(element.closest('.radio-list').length === 1) {
                error.insertAfter(element.closest('.radio-list'));
            } else if(element.hasClass('selectpicker')) {
                error.insertAfter(element.closest('.bootstrap-select'));
            } else if(element.closest('.input-group').length === 1) {
                error.insertAfter(element.closest('.input-group'));
            } else if(element.closest('.form-group-wrapper').length === 1) {
                if(element.attr('error_align') !== "undefined") {
                    error.insertAfter(element.closest('.form-group-wrapper')).addClass('text-center');
                } else {
                    error.insertAfter(element.closest('.form-group-wrapper'));
                }
            } else if(element.closest('.check').length === 1) {
                if(element.attr('error_align') !== "undefined") {
                    error.insertAfter(element.closest('.check')).addClass(element.attr('error_align'));
                } else {
                    error.insertAfter(element.closest('.check'));
                }
            } else {
                error.insertAfter(element);
            }
        },
    });
});