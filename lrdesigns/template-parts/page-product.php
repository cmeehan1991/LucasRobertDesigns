<?php
/*
 * @package: lrdesgins
 * @subpackage: woocommerce_product
 */

get_header();
?>
<div class='container-fluid'>
    <div class="row">
        <div class="col-md-9">
            <?php woocommerce_breadcrumb(); ?> 
            <div class="row">
        <div class="hidden-xs hidden-sm col-md-2">
	        <?php dynamic_sidebar('product-sidebar-left'); ?>
        </div>
                <div class="col-sm-12 col-md-8">
                    <?php get_template_part('template-parts/single', 'product'); ?>
                </div>
            </div>
        </div>
        <div class="hidden-xs hidden-sm col-md-2">
	        <?php dynamic_sidebar('product-sidebar-right'); ?>
        </div>
    </div>
</div>
<?php get_footer(); 