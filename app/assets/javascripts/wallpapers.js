$(document).ready(function() {

    $('#wallpaper').on('click', function() {
        $(this).parent().toggleClass('fil');
        $(this).parent().toggleClass('full');
    });



    $('a[data-toggle="wall-edit"]').on('click', function (event) {
        event.preventDefault();

        var id = $(this).data('wallId');
        var $modal = $('#wall-edit-modal');

        $('input[name="id"]', $modal).val(id);

        $modal.dialog({
            dialogClass: 'testor',
            modal: true,
            draggable: false,
            resizable: false
        });
    });

    /*
    $('#wall-edit-modal').on($.modal.OPEN, function(event, modal) {
        $('input[type="text"]', this).focus();
    });
    */
});