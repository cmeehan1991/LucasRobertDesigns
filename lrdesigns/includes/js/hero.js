var height = 0;
var width = 0;

$(document).ready(function(){
	adjustHero();
	$('.home-navbar').css("background-color", "transparent");
	$('.home-navbar').show();
	
	$('.hero-link').on('click', function(){
		$('html, body').animate({
			scrollTop: height + 2
		}, 2000);
	});
	
	// Set the background for the navbar on scroll
	$(window).on('scroll', function(){
		if($(window).scrollTop() >= height){	
			$('.home-navbar').css("background", "#ffffff");
		}
		if($(window).scrollTop() < height){
			$('.home-navbar').css("background", "transparent");	
		}
	});
	
	window.onresize = function(event){
		adjustHero();
	}
});

function adjustHero(){
	height = $(window).height();
	width = $(window).width();
	$('.hero-image').height(height);
	$('.hero-image').width(width);

	
	
}
