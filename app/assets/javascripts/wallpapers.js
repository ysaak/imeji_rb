$(document).ready(function() {

    $('#wallpaper').on('click', function() {
        $(this).parent().toggleClass('fil');
        $(this).parent().toggleClass('full');
    });


    $('#wall-edit-modal').on($.modal.OPEN, function(event, modal) {

        $('input[type="text"]', this).focus();
    });

});