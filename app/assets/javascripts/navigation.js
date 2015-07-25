$(document).ready(function() {

    $('#app_search').each(function() {
        var $search = $('#search');

        /* Set active state on label when input has focus */
        var $label = $('label', this);
        $search.focus(function() {
            $label.addClass('active')

            $('a[data-toggle="header-submenu"].active').click();

        }).blur(function() {
            $label.removeClass('active')
        });

        /* Remove trailing white spaces on form submit */
        $(this).on('submit', function() {
            $search.val($search.val().trim());
            return true;
        });
    });

    $('a[data-toggle="header-submenu"]').on('click', function(event) {
        var $this = $(this);

        $this.toggleClass('active');
        var target = $this.attr('href');
        $(target).slideToggle();

        if ($this.hasClass('active')) {

            $('<div class="header-overlay"></div>').on("click", function () {

                if ($('a[data-toggle="header-submenu"].active').length > 0) {
                    $this.click();

                }
                $(this).remove();
            }).appendTo($(document.body));
        }

        return false;
    });
});
