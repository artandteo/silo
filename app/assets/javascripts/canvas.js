
var color0;
var color1;
var color2;
var color3;
var color4;
var police;
var col_onglet;

document.addEventListener("turbolinks:load", function() {

    col0='#'+color0;
    col1='#'+color1;
    col2='#'+color2;
    col3='#'+color3;
    col4='#'+color4;


    $( ".top-bar, .footer, .tabs-content, .edition" ).css( "background-color", col2 );
    $( "#breadcrumb").css( "background-color", col3);
    $( ".color0" ).css( "background-color", col0 );
    $( ".color1" ).css( "background-color", col1 );
    $( ".color2" ).css( "background-color", col2 );
    $( ".draw_add i" ).css( "color", col2 );
    $( ".color3, .switch-paddle, .success" ).css( "background-color", col3 );
    $( ".color4" ).css( "background-color", col4 );
    $( "h1, h2, h3, h4, h5, h6, p, li, a" ).css( "font-family", police );

    $( ".enfant a, button").hover(function() {
      $(this).parent().parent().css( "opacity", "0.5" );
      }, function(){
      $(this).parent().parent().css( "opacity", "1" );
    });

    // $( ".is-active").click(function() {
    //   $(".active").css( "background-color", col2 );
    //   }, function(){
    //   $(".active").css( "background-color", "#F2F2F2" );
    // });

    $('.switch :checkbox').change(function(e){
      $(this).prop('checked') ?
      $('.toggle_admin').css( "display", "block" )
      :
      $('.toggle_admin').css( "display", "none" );
    //  var message = $(this).prop('checked') ? 'on' : 'off';
    //  document.getElementById("yes-no").value = message;
    });


    // Formulaire élèves

    $("#eleve_liste").change(function(){
        if ($(this).val() === "") {
            $(".hidden_field").fadeOut('fast');
            $(".hidden_field").css("display", "none")
        }
        else {
            $('input[type=hidden]#eleve_ancien_nom').val(this.value);
            $('input[type=text]#eleve_identifiant_eleve').val(this.value);
            $(".hidden_field").fadeIn('fast');
        }
    });
});
