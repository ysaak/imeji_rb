$(document).ready(function() {

    $('#tag_header_preview').on('click', function() {

        var wallId = $('#tag_wallpaper_id').val();

        var go = false;

        if (wallId.length > 0) {
            wallId = parseInt(wallId);

            if (!isNaN(wallId)) {
                go = true;
            }
        }

        console.log ('run preview : ' + go);
        console.log ('wallpaper_id : ' + wallId);

        if (go) {
            $.getJSON(
                wallpaperUrlTemplate.replace(':id', wallId),
                {},
                runHeaderPreview
            );
        }
    });

    function runHeaderPreview(data) {
        console.log(data);

        var bg_x = $('#tag_bg_x').val();
        var bg_y = $('#tag_bg_y').val();


        $('section.tag-brand')
            .css('background-image', 'url(\"' + data.img_path + '\")')
            .css('background-position', bg_x + ' ' + bg_y);

    }
});