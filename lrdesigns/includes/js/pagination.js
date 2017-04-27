/*
	This is being commented out because we are not currently using it. 
	
	$('document').ready(function(){
    countPosts();
    $('li').on('click', function(){
    });
    $('.page-link').on('click', function(){
       goToPage($(this).data('page')); 
    });
});

function countPosts(){
	var product_cat = '';
	if($(location).attr('href').indexOf("necklaces") > -1){
	    product_cat = 'necklaces';
    }else if($(location).attr('href').indexOf('enhancer') > -1){
	    product_cat = 'enhancers';
    }else if($(location).attr('href').indexOf('earring') > -1){
	    product_cat = 'earrings';
    }else if($(location).attr('href').indexOf('bracelet') > -1){
	    product_cat = 'bracelets';
    }else if($(location).attr('href').indexOf('set') > -1){
	    product_cat = 'sets';
    }else if($(location).attr('href').indexOf('accessories') > -1){
	    product_cat = 'accessories';
    }
        $.ajax({
        url:ajaxurl,
        data:{action:"num_pages_ajax", 'product_cat':product_cat},
        success:function(results){
            $('.pagination').append('')
            for(i = 1; i <= results; i++){
                $('.pagination').append('<li><a href="#page_'+i+'" class="page-link" data-page="'+i+'" onclick="return goToPage('+i+')">'+i+'</a></li>');
            }
        },error:function(error){
            console.log('error');
        }
    });
}

function goToPage(page){
	 var product_cat = '';
    if($(location).attr('href').indexOf("necklaces") > -1){
	    product_cat = 'necklaces';
    }else if($(location).attr('href').indexOf('enhancer') > -1){
	    product_cat = 'enhancers';
    }else if($(location).attr('href').indexOf('earring') > -1){
	    product_cat = 'earrings';
    }else if($(location).attr('href').indexOf('bracelet') > -1){
	    product_cat = 'bracelets';
    }else if($(location).attr('href').indexOf('set') > -1){
	    product_cat = 'sets';
    }else if($(location).attr('href').indexOf('accessories') > -1){
	    product_cat = 'accessories';
    }
    
    $('.loader').attr('hidden', false);
    $.ajax({
        url:ajaxurl, 
        data:{
            action:"go_to_page_ajax",
            'page':page-1,
			'product_cat': product_cat
        },
        method: 'post',
        success:function(results){
    $('.loader').attr('hidden', true);
            $("#products").html(results);
        },error:function(error){
            console.log('error');
        }
    });
    return false;
}
*/