
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

document.addEventListener("turbolinks:load", function() {
    col0='#'+color0;
    col1='#'+color1;
    col2='#'+color2;
    col3='#'+color3;
    col4='#'+color4;
    img="/img/"+image;

    // --------- MODIFICATION DOM EN FONCTION DES PREFERENCES -----------

    $( ".top-bar, .footer, .tabs-content, .edition" ).css( "background-color", col2 );
    $( "#breadcrumb").css( "background-color", col3);
    $( ".color0" ).css( "background-color", col0 );
    $( ".color1" ).css( "background-color", col1 );
    $( ".color2" ).css( "background-color", col2 );
    $( ".draw_add i" ).css( "color", col2 );
    $( ".color3, .switch-paddle, .success" ).css( "background-color", col3 );
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

    // Modification de l'opacity sur les élèments cliquables

    $( ".enfant a, button").hover(function() {
      $(this).parent().parent().css( "opacity", "0.5" );
      }, function(){
      $(this).parent().parent().css( "opacity", "1" );
    });
    $( ".box").hover(function() {
      $(this).css( "opacity", "0.5" );
      }, function(){
      $(this).css( "opacity", "1" );
    });

    // Aperçu du lien draw au clic du a href du fichier dans iframe unique

    $( "a.lk_apercu").hover(function() {
      var src = ($(this).attr('href'));
      $( "iframe" ).attr('src',src);
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
});
