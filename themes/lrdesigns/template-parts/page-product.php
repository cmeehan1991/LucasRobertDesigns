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
                <div class="col-md-12">
                    <?php get_template_part('template-parts/single', 'product'); ?>
                </div>
            </div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
</div>
<?php get_footer(); 