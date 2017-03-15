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