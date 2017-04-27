<?php


function lrdesigns_bootstrap(){
   wp_register_style('bootstrap.min.css', BLOG_URI . "/includes/bootstrap/css/bootstrap.min.css");
   wp_enqueue_style('bootstrap.min.css');
      
   wp_enqueue_script('bootstrap.min.js', BLOG_URI . "/includes/bootstrap/js/bootstrap.min.js", array('jquery'));
}
add_action('wp_enqueue_scripts', 'lrdesigns_bootstrap');
