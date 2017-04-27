<?php


function lrdesigns_loadmore(){
    wp_register_script('loadmore',BLOG_URI . '/includes/js/loadmore.js',array(),'',false);
    wp_enqueue_script('loadmore');
}
add_action('wp_enqueue_scripts','lrdesigns_loadmore');

add_action('wp_head','pluginname_ajaxurl');

function pluginname_ajaxurl() {
?>
<script type="text/javascript">
var ajaxurl = '<?php echo admin_url('admin-ajax.php'); ?>';
</script>
<?php 
}



function lrdesigns_pagination(){
    wp_enqueue_script('pagination', BLOG_URI . '/includes/js/pagination.js', array('jquery'), '', false);
}
add_action('wp_enqueue_scripts', 'lrdesigns_pagination');

function lrdesigns_email(){
    wp_enqueue_script('email', BLOG_URI . '/includes/js/email.js', array('jquery'), '', false);
}
add_action('wp_enqueue_scripts', 'lrdesigns_email');


add_action('wp_enqueue_scripts','lrdesigns_vendors');
function lrdesigns_vendors(){
	wp_enqueue_script('vendors', BLOG_URI . '/includes/js/vendors.js', array('jquery'));
}

add_action('wp_enqueue_scripts','lrdesigns_lists');
function lrdesigns_lists(){
	wp_enqueue_script('csv', BLOG_URI . '/includes/js/jquery.csv.min.js', array('jquery'));
	wp_enqueue_script('lists', BLOG_URI . '/includes/js/lists.js', array('jquery', 'csv'));
}

add_action('wp_enqueue_scripts','lrdesigns_hero');
function lrdesigns_hero(){
	wp_enqueue_script('hero', BLOG_URI . '/includes/js/hero.js');
}

add_action('wp_enqueue_scripts','lrdesigns_product');
function lrdesigns_product(){
	wp_enqueue_script('product', BLOG_URI . '/includes/js/product.js');
}



