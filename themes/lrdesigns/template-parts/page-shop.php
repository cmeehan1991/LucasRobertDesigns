<?php
/*
 * package:lrdesigns
 * @subpackage:woocommerce
 */
get_header();
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="col-xs-12 col-md-12">
                <?php woocommerce_breadcrumb(); ?>
            </div>
            </row>
            <div class='row'>
                <div class="col-xs-12 col-md-12">
                    <header align='center'><h1>Shop</h1></header>
                </div>
            </div>
            <div class='row'>
                <div class='col-xs-6 col-md-offset-3 col-md-3' align="center">
                    <a href="/product-category/necklaces">
                        <img src="<?php echo BLOG_URI; ?>/images/LR-103-300x300.jpg" alt="necklaces" class="category-image"/>
                        <h3>Necklaces</h3>
                    </a>
                </div>
                <div class='col-xs-6 col-md-3' align="center">
                    
                    <a href="/product-category/bracelet">
                        <img src="<?php echo BLOG_URI; ?>/images/LR-105.jpg" alt="bracelets" class="category-image"/>
                        <h3>Bracelets</h3>
                    </a>
                </div>
            </div>
            <div class='row'>
                <div class='col-xs-6 col-md-offset-3 col-md-3' align="center">
                    <a href="/product-category/enhancer">
                        <img src="<?php echo BLOG_URI; ?>/images/LR-835-300x300.jpg" alt="enhancers" class="category-image"/>
                        <h3>Enhancers</h3>
                    </a>
                    
                </div>
                <div class='col-xs-6 col-md-3' align="center">
                    <a href="/product-category/earring">
                        <img src="<?php echo BLOG_URI; ?>/images/LR-111-300x300.jpg" alt="Earrings" class="category-image"/>
                        <h3>Earrings</h3>
                    </a>
                    
                </div>
            </div>
            <!--
            <div class='row'>
                <div class='col-md-12' align="center">
                    <a href="">
                        <img src="<?php echo BLOG_URI; ?>/images/LR-105.jpg" alt="necklaces" style="width:200px; height:200px;"/>
                        <h1>Sets</h1>
                    </a>
                </div>
            </div>
        -->
        </div>
    </div>
</div>