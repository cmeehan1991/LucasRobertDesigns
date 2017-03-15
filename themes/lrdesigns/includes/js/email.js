function sendEmail(){
    data = {
        'name': $('input[name="name"]').val(),
        'email':$('input[name="email"]').val(),
        'phone':$('input[name="tel"]').val(),
        'company':$('input[name="company"]').val(),
        'message':$('textarea[name="message"]').val(),
        action: 'email_ajax'
    };
    console.log(data);
    $.ajax({
        url:ajaxurl, 
        data:data,
        method:'post',
        success:function(response){
           $('.contact-form').fadeOut('now');
           $('.contact-message').html("<h1>Your Email has been sent.</h1><h3>We will be in touch with you shortly.</h3>").css('color', 'green').fadeIn('slow');
        },error:function(error){
            console.log('error');
        }
    });
    return false;
}

