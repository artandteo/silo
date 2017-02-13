
var color0;
var color1;
var color2;
var color3;
var color4;
var police;

document.addEventListener("turbolinks:load", function() {

    col0='#'+color0;
    col1='#'+color1;
    col2='#'+color2;
    col3='#'+color3;
    col4='#'+color4;

    $( ".top-bar" ).css( "background-color", col2 );
    $( "footer" ).css( "background-color", col2 );
    $( "#breadcrumb").css( "background-color", col3);
    $( ".color0" ).css( "background-color", col0 );
    $( ".color1" ).css( "background-color", col1 );
    $( ".color2" ).css( "background-color", col2 );
    $( ".color3" ).css( "background-color", col3 );
    $( ".color4" ).css( "background-color", col4 );
    $( "h1, h2, h3, h4, h5, h6, p, li, a" ).css( "font-family", police );


    // $( ".col_config_1" ).click(function() {
    //   sessionStorage.setItem("couleur0","#FF5B2B");
    //   sessionStorage.setItem("couleur1","#B1221C");
    //   sessionStorage.setItem("couleur2","#34393E");
    //   sessionStorage.setItem("couleur3","#8CC6D7");
    //   sessionStorage.setItem("couleur4","#FFDA8C");
    //   window.location.reload(true);
    // });

    // $( ".col_config_2" ).click(function() {
    //   sessionStorage.setItem("couleur0","#FFF200");
    //   sessionStorage.setItem("couleur1","#E8860C");
    //   sessionStorage.setItem("couleur2","#FF0000");
    //   sessionStorage.setItem("couleur3","#780CE8");
    //   sessionStorage.setItem("couleur4","#0D8AFF");
    //   window.location.reload(true);
    // });


    // $( ".col_config_3" ).click(function() {
    //   sessionStorage.setItem("couleur0","#8AFF80");
    //   sessionStorage.setItem("couleur1","#E8D280");
    //   sessionStorage.setItem("couleur2","#FF9680");
    //   sessionStorage.setItem("couleur3","#BC80E8");
    //   sessionStorage.setItem("couleur4","#80D8FF");
    //   window.location.reload(true);
    // });
    // $( ".pol_1" ).click(function() {
    //   sessionStorage.setItem("police","Lato");
    //   window.location.reload(true);
    // });
    // $( ".pol_2" ).click(function() {
    //   sessionStorage.setItem("police","Roboto");
    //   window.location.reload(true);
    // });

    $( ".enfant a").hover(function() {
      $(this).parent().parent().css( "opacity", "0.5" );
      }, function(){
      $(this).parent().parent().css( "opacity", "1" );
    });

    $('.switch :checkbox').change(function(e){
      $(this).prop('checked') ?
      $('.toggle_admin').css( "display", "block" )
      :
      $('.toggle_admin').css( "display", "none" );
    //  var message = $(this).prop('checked') ? 'on' : 'off';
    //  document.getElementById("yes-no").value = message;
    });

});
