<?php

function lrdesigns_styles(){
    wp_register_style('style',BLOG_URI.'/style.css');
    wp_enqueue_style('style');
}

add_action('wp_enqueue_scripts','lrdesigns_styles');

function lrdesigns_navstyles(){
    wp_register_style('navstyle', BLOG_URI.'/includes/styles/styles-navmenu.css');
    wp_enqueue_style('navstyle');
}
add_action('wp_enqueue_scripts','lrdesigns_navstyles');

function lrdesigns_homestyle(){
    wp_register_style('homestyle',BLOG_URI.'/includes/styles/styles-home.css');
    wp_enqueue_style('homestyle');
}
add_action('wp_enqueue_scripts','lrdesigns_homestyle');

function lrdesigns_productsstyle(){
    wp_register_style('productsstyle',BLOG_URI.'/includes/styles/styles-products.css');
    wp_enqueue_style('productsstyle');
}
add_action('wp_enqueue_scripts','lrdesigns_productsstyle');

function lrdesigns_globalstyle(){
    wp_register_style('globalstyle', BLOG_URI.'/includes/styles/styles-global.css');
    wp_enqueue_style('globalstyle');
}
add_action('wp_enqueue_scripts','lrdesigns_globalstyle');

function lrdesigns_shopstyle(){
    wp_register_style('shopstyle',BLOG_URI.'/includes/styles/styles-shop.css');
    wp_enqueue_style('shopstyle');
}
add_action('wp_enqueue_scripts','lrdesigns_shopstyle');

function lrdesigns_accountstyle(){
    wp_register_style('accountstyle',BLOG_URI.'/includes/styles/styles-account.css');
    wp_enqueue_style('accountstyle');
}
add_action('wp_enqueue_scripts','lrdesigns_accountstyle');

function lrdesigns_sidebarstyle(){
	wp_enqueue_style('sidebar-style', BLOG_URI . '/includes/styles/styles-sidebars.css');
}
add_action('wp_enqueue_scripts', 'lrdesigns_sidebarstyle');