/**
 * Created by ysaak on 06/07/15.
 */

$(document).ready(function() {

    var load = false; // aucun chargement de commentaire n'est en cours
    var hasMore = true;

    var page = 1;

    /* la fonction offset permet de récupérer la valeur X et Y d'un élément
     dans une page. Ici on récupère la position du dernier div qui
     a pour classe : "#wall-lister .wallthumb" */
    var offset = $('#wall-lister .wallthumb:last').offset();

    $(window).scroll(function(){ // On surveille l'évènement scroll

        /* Si l'élément offset est en bas de scroll, si aucun chargement
         n'est en cours, si le nombre de commentaire affiché est supérieur
         à 5 et si tout les commentaires ne sont pas affichés, alors on
         lance la fonction. */
        if ((offset.top-$(window).height() <= $(window).scrollTop()) && !load && hasMore) {

            // la valeur passe à vrai, on va charger
            load = true;

            //On affiche un loader
            // FIXME !!
            //$('.loadmore').show();

            console.log('page = ' + page);

            page = parseInt(page) + 1;
            console.log('new page = ' + page);


            //On lance la fonction ajax
            $.ajax({
                url: searchUrl,
                type: 'post',
                dataType: 'json',
                data: { q: searchQuery, page: page },
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
                },

                //Succès de la requête
                success: function(data) {

                    hasMore = data.wallpapers.length == data.limit

                    var template = $('#search-result-tpl').html();

                    $.each(data.wallpapers, function(index, item){

                        var entry = template.replace('{{thumb_path}}', item.thumb_path)
                        entry = entry.replace('{{path}}', item.path)
                        entry = entry.replace('{{width}}', item.width).replace('{{height}}', item.height);

                        $('#wall-lister').append(entry)
                    });


                    //On masque le loader
                    //$('.loadmore').fadeOut(500);
                    offset = $('#wall-lister .wallthumb:last').offset();
                    //On remet la valeur à faux car c'est fini
                    load = false;
                }
            });
        }


    });
})