var $ = jQuery;
var page = 1;
var ppp = 15;
var windowHeight = 0;
var position = 0;
var lastHeight = 0;
$(document).ready(function () {
    $("#load-more").on('click', function () {
        loadMore();
    });
    
     $('.product-link').on('click', function () {
        $('.loader').attr('hidden', false);
    });

    $(document).on('load', function () {
        $('.loader').attr('hidden', true);
    });
    
    height = $(document).height();
    
});

$(window).on('scroll', function(){
	position = $(window).scrollTop();
	if(position > height/2 && $('#load-more').is(":hidden") != true){
		console.log(position)
		height = $(document).height();
		loadMore(); 
	}
});

function loadMore() {
    $('.loader').attr('hidden', false);
    
    var product_cat = '';
    if($(location).attr('href').indexOf("necklaces") > -1){
	    product_cat = 'necklaces';
    }else if($(location).attr('href').indexOf('enhancer') > -1){
	    product_cat = 'enhancer';
    }else if($(location).attr('href').indexOf('earring') > -1){
	    product_cat = 'earring';
    }else if($(location).attr('href').indexOf('bracelet') > -1){
	    product_cat = 'bracelet';
    }else if($(location).attr('href').indexOf('set') > -1){
	    product_cat = 'set';
    }else if($(location).attr('href').indexOf('accessories') > -1){
	    product_cat = 'accessories';
    }
    $.post(ajaxurl, {
        action: "more_products_ajax",
        'ppp': ppp,
        'offset': (page * ppp) + 1,
        'product_cat': product_cat
    }).success(function (posts) {
	    console.log(product_cat);
        $('.loader').attr('hidden', true);
        if (posts != 'no more') {
            $("#products").append(posts);
        }else{
            $('#load-more').hide();
        }
        page += 1;
    });
}

function openTab(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the link that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}