<?php

function email_ajax() {
    // Set the mail parameters
    $to = "cmeehan1991@gmail.com";
    $subject = "Lucas Robert Webmail";


    // Get the user input
    $name = filter_input(INPUT_POST, 'name');
    $email = filter_input(INPUT_POST, 'email');
    $tel = filter_input(INPUT_POST, 'tel');
    $company = filter_input(INPUT_POST, 'company');
    $message_text = filter_input(INPUT_POST, 'message');

    $message = "<html>"
            . "<head>"
            . "<title>Lucas Robert Webmail Request</title>"
            . "</head>"
            . "<body>"
            . "<table>"
            . "<tr><td><b>Name:</b></td><td>$name</td></tr>"
            . "<tr><td><b>Email:</b></td><td>$email</td></tr>"
            . "<tr><td><b>Phone:</b></td><td>$tel</td></tr>"
            . "<tr><td><b>Company:</b></td><td>$company</td></tr>"
            . "<tr><td colspan='2'>$message_text</td></tr>"
            . "</table>"
            . "</body>"
            . "</html>";
    
    
    // Always set content-type when sending HTML email
    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";

    // More headers
    $headers .= 'From: <webmail@lucasrobertdesigns.com>' . "\r\n";
    //$headers .= 'Cc: myboss@example.com' . "\r\n";

    mail($to, $subject, $message, $headers);
    
    die;
}
add_action('wp_ajax_email_ajax', 'email_ajax');
add_action('wp_ajax_nopriv_email_ajax', 'email_ajax');
