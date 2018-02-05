// var helpon;
// x1 = 10; x2 = 10; x3 = 10; x4 = 10; x5 = 10; x6 = 10;
// y1 = 10; y2 = 10; y3 = 10; y4 = 10; y5 = 10; y6 = 10;

document.addEventListener("turbolinks:load", function() {

// -------------------------------------------------------------
// ------------------------- HELP ------------------------------
// -------------------------------------------------------------

  // // --------- MODIFICATION DOM EN FONCTION DES PREFERENCES ---------
  //
  //   $(".cache").css("display", helpon);
  //   $("div#info1").css({
  //     position: 'absolute',
  //     top: y1+'px',
  //     left: x1+'px'
  //   });
  //   $("#info2>span").css({
  //     position: 'absolute',
  //     top: (y2+20)+'px',
  //     left: (x2-12)+'px'
  //   });
  //   $("#info2>.txt_info").css({
  //     position: 'absolute',
  //     top: (y2+80)+'px',
  //     left: (x2-30)+'px'
  //   });
  //   $("#info3>span").css({
  //     position: 'absolute',
  //     top: (y3+20)+'px',
  //     right: (x3)+'px'
  //   });
  //   $("#info3>.txt_info").css({
  //     position: 'absolute',
  //     top: (y3+80)+'px',
  //     right: (x3-12)+'px'
  //   });
  //   $("div#info4").css({
  //     position: 'absolute',
  //     top: y4+'px',
  //     right: x4+'px'
  //   });
  //   $("#info5>span").css({
  //     position: 'absolute',
  //     top: (y5+20)+'px',
  //     left: (x5)+'px'
  //   });
  //   $("#info5>.txt_info").css({
  //     position: 'absolute',
  //     top: (y5+80)+'px',
  //     left: (x5-18)+'px'
  //   });
  //   $("div#info6").css({
  //     position: 'absolute',
  //     top: (y6-15)+'px',
  //     left: (x6+35)+'px'
  //   });
  //
  //
  //   $("a#demande-aide").click(function() {
  //       helpon = "inline-block";
  //       y1 = $('.box_add').position().top + ($(".box_add").height())/2;
  //       x1 = $('.box_add').position().left + ($(".box_add").width())/2 + 20;
  //       y2 = $('.pref-logo').position().top + ($(".pref-logo").height())/2;
  //       x2 = $('.pref-logo').position().left + ($(".pref-logo").width())/2;
  //       y3 = $('.config-logo').position().top + ($(".config-logo").height())/2;
  //       x3 = $('.top-bar').width() - $('.config-logo').position().left - 10;
  //       y4 = $('.out').position().top - 35;
  //       x4 = $('.top-bar').width() - $('.out').position().left - 25;
  //       y5 = $('.main_desk>.box:first-child').find('a:first-child').position().top + 140;
  //       x5 = $('.main_desk>.box:first-child').find('a:first-child').position().left - 42;
  //       y6 = $('.main_desk>.box:first-child').find('a:nth-child(2)').position().top;
  //       x6 = $('.main_desk>.box:first-child').find('a:nth-child(2)').position().left;
  //   });

  // ------------- Affichage du div aide ----------------

    // $(".cache").click(function() {
    //   helpon = "none";
    //   $(".cache").css("display", helpon);
    // });

  // ------------------- AIDE VIDEOS ---------------------



	//Lorsque vous cliquez sur un lien de la classe poplight
	$('a.poplight').on('click', function() {
		var popID = $(this).data('rel'); //Trouver la pop-up correspondante
		var popWidth = $(this).data('width'); //Trouver la largeur

		//Faire apparaitre la pop-up et ajouter le bouton de fermeture
		$('#' + popID).fadeIn().css({ 'width': popWidth}).prepend('<a href="#" class="close"><i class="fa fa-times-circle size-36 btn_close" title="Close Window" aria-hidden="true"></i></a>');

		//Récupération du margin, qui permettra de centrer la fenêtre - on ajuste de 80px en conformité avec le CSS
		// var popMargTop = ($('#' + popID).height() + 80) / 2;
		// var popMargLeft = ($('#' + popID).width() + 80) / 2;

		//Apply Margin to Popup
		 $('#' + popID).css({
		 	'bottom' : 0,
		 	'right' : 0
		 });

		//Apparition du fond - .css({'filter' : 'alpha(opacity=80)'}) pour corriger les bogues d'anciennes versions de IE
		// $('body').append('<div id="fade"></div>');
		// $('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();

		return false;
	});


	//Close Popups and Fade Layer
	$('body').on('click', 'a.close, #fade', function() { //Au clic sur le body...
		$('#fade , .popup_block').fadeOut(function() {
			$('#fade, a.close').remove();
	}); //...ils disparaissent ensemble

		return false;
	});

// -------------------- POPUP VIDEO AIDE --------------------------


	//Lorsque vous cliquez sur un lien de la classe poplight
	$('a.popvid').on('click', function() {
		var popID = $(this).data('rel'); //Trouver la pop-up correspondante
		var popWidth = $(this).data('width'); //Trouver la largeur

		//Faire apparaitre la pop-up et ajouter le bouton de fermeture
		$('#' + popID).fadeIn().css({ 'width': popWidth}).prepend('<a href="#" class="close"><i class="fa fa-times-circle size-36 btn_close" title="Close Window" aria-hidden="true"></i></a>');

		//Récupération du margin, qui permettra de centrer la fenêtre - on ajuste de 80px en conformité avec le CSS
		var popMargTop = ($('#' + popID).height() + 80) / 2;
		var popMargLeft = ($('#' + popID).width() + 80) / 2;

		//Apply Margin to Popup
		$('#' + popID).css({
  		'top' : popMargTop,
  		'left' : popMargLeft
		});

		//Apparition du fond - .css({'filter' : 'alpha(opacity=80)'}) pour corriger les bogues d'anciennes versions de IE
		$('body').append('<div id="fade"></div>');
		$('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn();

		return false;
	});

});
