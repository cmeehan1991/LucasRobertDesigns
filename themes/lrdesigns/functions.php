<?php

define('BLOG_URI', get_template_directory_uri());
define('BLOG_PATH', get_template_directory());
define('LR_VERSION', '0.0.1');
define('LR_TEXTDOMAIN', 'lrdesign');

update_option('siteurl', 'http://lrdev.cbmwebdevelopment.com');
update_option('home', 'http://lrdev.cbmwebdevelopment.com');

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

