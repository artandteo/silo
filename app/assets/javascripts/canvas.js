
var col0 = sessionStorage.getItem("couleur0");
var col1 = sessionStorage.getItem("couleur1");
var col2 = sessionStorage.getItem("couleur2");
var col3 = sessionStorage.getItem("couleur3");
var col4 = sessionStorage.getItem("couleur4");
var police = sessionStorage.getItem("police");

document.addEventListener("turbolinks:load", function() {

    $( ".top-bar" ).css( "background-color", col2 );
    $( "footer" ).css( "background-color", col2 );
    $( ".color0" ).css( "background-color", col0 );
    $( ".color1" ).css( "background-color", col1 );
    $( ".color2" ).css( "background-color", col2 );
    $( ".color3" ).css( "background-color", col3 );
    $( ".color4" ).css( "background-color", col4 );
    $( "h1, h2, h3, h4, h5, h6, p, li, a" ).css( "font-family", police );

    $( ".col_config_1" ).click(function() {
      sessionStorage.setItem("couleur0","#FF5B2B");
      sessionStorage.setItem("couleur1","#B1221C");
      sessionStorage.setItem("couleur2","#34393E");
      sessionStorage.setItem("couleur3","#8CC6D7");
      sessionStorage.setItem("couleur4","#FFDA8C");
      window.location.reload(true);
    });
    $( ".col_config_2" ).click(function() {
      sessionStorage.setItem("couleur0","#FFF200");
      sessionStorage.setItem("couleur1","#E8860C");
      sessionStorage.setItem("couleur2","#FF0000");
      sessionStorage.setItem("couleur3","#780CE8");
      sessionStorage.setItem("couleur4","#0D8AFF");
      window.location.reload(true);
    });
    $( ".col_config_3" ).click(function() {
      sessionStorage.setItem("couleur0","#8AFF80");
      sessionStorage.setItem("couleur1","#E8D280");
      sessionStorage.setItem("couleur2","#FF9680");
      sessionStorage.setItem("couleur3","#BC80E8");
      sessionStorage.setItem("couleur4","#80D8FF");
      window.location.reload(true);
    });
    $( ".pol_1" ).click(function() {
      sessionStorage.setItem("police","Lato");
      window.location.reload(true);
    });
    $( ".pol_2" ).click(function() {
      sessionStorage.setItem("police","Roboto");
      window.location.reload(true);
    });

    $( ".box a").hover(function() {
      $(this).css( "opacity", "0.5");
      }, function(){
      $(this).css( "opacity", "1");
    });

});
