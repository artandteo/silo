
var color0;
var color1;
var color2;
var color3;
var color4;
var police;
var image;
var margin;
var minwidth;
var radius;
var helpon;
var tabnumber;
x = 10;
y = 10;

document.addEventListener("turbolinks:load", function() {

    col0='#'+color0;
    col1='#'+color1;
    col2='#'+color2;
    col3='#'+color3;
    col4='#'+color4;
    img="/img/"+image;
    tabnumber = sessionStorage.tabst.charAt(sessionStorage.tabst.length-1);


    // --------- MODIFICATION DOM EN FONCTION DES PREFERENCES -----------

    $( ".tabs-title").removeClass('is-active');
    $("#tabt"+tabnumber).addClass('is-active');
    $( ".top-bar, .footer, .tabs-content" ).css( "background-color", col2 );
    $( "#breadcrumb").css( "background-color", col3);
    $( ".color0" ).css( "background-color", col0 );
    $( ".color1" ).css( "background-color", col1 );
    $( ".color2" ).css( "background-color", col2 );
    $( ".color3" ).css( "background-color", col3 );
    $( ".draw_add i" ).css( "color", col2 );
    $( ".is-active>a" ).css("background", col2);
    $( ".switch-paddle, button.success" ).css( "background-color", col3 );
    $( ".color4" ).css( "background-color", col4 );
    $( "h1, h2, h3, h4, h5, h6, p, li, a" ).css( "font-family", police );
    $( "#bandeau img" ).attr({
      'src' : img,
      width : '100%',
      height : '100%'
    });
    if(image == '') { $("#bandeau").css("max-height", "0"); }
    $( ".box, .box_add" ).css ({
      margin : margin,
      'min-width' : minwidth,
      'border-radius' : radius
    });


    // $('html').fadeTo('slow',1);

    // PROGRESS BAR
    $('.upfile').change(function(){
        var txtfiles = $(this)[0].files;
        for (var i = 0; i < txtfiles.length; i++) {
            $(".datafile").append("<li>"+txtfiles[i].name+"</li>");
        }
        $('.versement').css('visibility','visible');
    });

    $(".upload").on('submit', function(e){
        e.preventDefault();
            $(this).ajaxSubmit({
                beforeSend:function(){
                    $(".prog").show();
                    $(".prog").attr('value','0');
                },
                uploadProgress:function(event,position,total,percentComplete){
                $(".prog").attr('value',percentComplete);
                $(".percent").html(percentComplete+'%')
                },
                success:function(data){
                    $(".here").html("Téléversement effectué avec succès");
                }
            });
    });

    // apparition box_buttons au survol

    $( ".box").hover(function() {
      $(this).children( ".box_buttons").fadeIn('500');
    }, function() {
      $(this).children( ".box_buttons").fadeOut('1500');
    });

    // Effet scale sur box_buttons

    $( ".box_buttons td *").hover(function() {
      $( this ).animate( {"font-size": "1.1em", "font-size": "1.3em" } );
    }, function() {
      $( this ).animate( {"font-size": "1.3em", "font-size": "1.1em" } );
    });

    // Fonctionnalité de la checkbox Tout sélectionner dans Reveal de visibilité

    $(".toutsel").click(function(){
      if ($( ".toutsel").is(':checked')) {
        $(".mesElev").prop('checked', true);
      }
      else {
        $(".mesElev").prop('checked', false);
      }
    });

    // Rafraichissement fenetre après fermeture d'un reveal sans valider

    $(".close-button").click(function() {
      window.location.reload()
    });

    // Action et changement de couleur lors du click sur un draw

    $( ".tabs-title>a" ).click(function() {
      sessionStorage.tabst = this;
      $( ".tabs-title>a" ).css( "background", "#F2F2F2");
      $( "iframe" ).attr('src','');
      $(this).css( "background", col2 );
      $( ".apercu").css('display', 'none');
      $( ".apercu>iframe" ).attr('src','');
    });

    // Action et changement de couleur lors du click sur un accordion des canvas

    $( ".accordion-item>a" ).click(function() {
      $( ".accordion-item>a" ).css( "background", "#FFF").css("color","#000");
      $(this).css( "background", col2 ).css("color","#FFF");
    });

    // Modification de l'opacity sur les élèments cliquables

    $( ".enfant a").hover(function() {
      $(this).parent().parent().css( "opacity", "0.7" );
      $( this ).animate( {"font-size": "1.7em", "font-size": "1.9em" } );
      }, function(){
      $(this).parent().parent().css( "opacity", "1" );
      $( this ).animate( {"font-size": "1.9em", "font-size": "1.7em" } );
    });
    $( ".box").hover(function() {
      $(this).css( "opacity", "0.7" );
      }, function(){
      $(this).css( "opacity", "1" );
    });

    // Aperçu du lien draw au clic du a href du fichier dans iframe unique

    var windowssize = $(window).width();
    if (windowssize < 800) {
       $(".mobile_only").css("display", "inline-block");
    }
    else
    {
      $( "a.lk_apercu").click(function() {
        var src = ($(this).attr('data'));
        var ext = src.charAt(src.length-3)+src.charAt(src.length-2)+src.charAt(src.length-1);
        if (ext != 'dwg' && ext != 'lsx' && ext != 'xls' && ext != 'doc' && ext != 'ocx') {
            $(".apercu").css('display', 'block');
            $(".apercu>iframe").attr('src', src);
            $(".close-apercu").css('display', 'block');
            if (ext === 'mp3') {
                $(".apercu>iframe").attr('height', '50px');
            }
            else if (ext === 'pdf') {
                $(".apercu>iframe").attr('height', '800px');
            }
            else $(".apercu>iframe").attr('height', '480px');
        }
        if (ext === 'doc' || ext === 'ocx' || ext === 'xls' || ext === 'lsx') {
            var src2 = 'https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fsilo.artandteo.com' + encodeURIComponent(src);
            $(".apercu").css('display', 'block');
            $(".apercu>iframe").attr('src', src2);
            $(".close-apercu").css('display', 'block');
            $(".apercu>iframe").attr('height', '800px');
        }
      });
    }
    //bouton close aperçu
    $( ".close-apercu").click(function() {
      $( ".apercu").css('display', 'none');
      $( ".apercu>iframe" ).attr('src','');
    });

    // Extension du a href des box à toute la div enfant

    $(".box > .enfant").on("click", function() {
        window.location = $(this).children("a").attr("href");
    });

    // Action du bouton switch toggle_admin

    $('.switch :checkbox').change(function(e){
      if ($(this).prop('checked') == true) {
        $('.toggle_admin').css( "display", "block" );
        $('.box_add').css( "display", "flex" );
      }
      else {
        $('.toggle_admin').css( "display", "none" );
      }
    });

    // Formulaire élèves

    $("#eleve_liste").change(function(){
        if ($(this).val() === "") {
            $(".hidden_field").fadeOut('fast');
            $(".hidden_field").css("display", "none");
        }
        else {
            $('input[type=hidden]#eleve_ancien_nom').val(this.value);
            $('input[type=text]#eleve_identifiant_eleve').val(this.value);
            $(".hidden_field").fadeIn('fast');
        }
    });

    // MENU ELLIPSIS

    $("#ellipsis, #menuellipsis").hover(function() {
        $("#menuellipsis").css("display", "block");
    }, function() {
        $("#menuellipsis").css("display", "none");
    });

});