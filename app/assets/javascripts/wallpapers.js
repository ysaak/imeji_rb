$(document).ready(function() {

    $('#wallpaper').on('click', function() {
        $(this).parent().toggleClass('fil');
        $(this).parent().toggleClass('full');
    });
});