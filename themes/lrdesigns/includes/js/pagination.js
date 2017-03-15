$('document').ready(function(){
    countPosts();
    $('li').on('click', function(){
       console.log('hello, world'); 
    });
    $('.page-link').on('click', function(){
        console.log('hello');
       goToPage($(this).data('page')); 
    });
});

function countPosts(){
    $.ajax({
        url:ajaxurl,
        data:{action:"num_pages_ajax"},
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
    $('.loader').attr('hidden', false);
    $.ajax({
        url:ajaxurl, 
        data:{
            action:"go_to_page_ajax",
            'page':page-1
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