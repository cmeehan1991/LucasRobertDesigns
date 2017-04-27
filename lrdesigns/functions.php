<?php

define('BLOG_URI', get_template_directory_uri());
define('BLOG_PATH', get_template_directory());
define('LR_VERSION', '0.0.1');
define('LR_TEXTDOMAIN', 'lrdesign');

add_action( 'after_setup_theme', 'lrdesigns_setup' );

function lrdesigns_setup() {
//add_theme_support( 'wc-product-gallery-zoom' );
add_theme_support( 'wc-product-gallery-lightbox' );
//add_theme_support( 'wc-product-gallery-slider' );
}


include(BLOG_PATH . '/includes/functions/functions-pagination.php');
include(BLOG_PATH . '/includes/functions/functions-layout.php');
include(BLOG_PATH . '/includes/functions/functions-styles.php');
include(BLOG_PATH . '/includes/functions/functions-pluginsupport.php');
include(BLOG_PATH . '/includes/functions/functions-loadmore.php');
include(BLOG_PATH . '/includes/functions/functions-scripts.php');
include(BLOG_PATH . '/includes/functions/functions-email.php');
include(BLOG_PATH . '/includes/functions/functions-sidebars.php');

//Hide the admin bar
show_admin_bar(false);

