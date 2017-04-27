<?php

	$product_cat = get_the_terms($post->ID, 'product_cat')[0];
	//$paged = ( get_query_var('page') ) ? get_query_var('page') : 1;
	$posts_per_page = '15';
	
	$shopArgs = array(
	'post_type' => 'product',
	'posts_per_page' => $posts_per_page,
	'paged' => $paged,
	'orderby' => 'date',
	'product_cat'=>$product_cat->slug,
	'order' => 'DESC',
    'meta_query' => array(array('key'=>'_thumbnail_id'))
	);
	$shopLoop = new WP_Query($shopArgs);

	get_header();
	
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <?php woocommerce_breadcrumb();?>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <?php _e('<h1 align="center">'.$product_cat->name.'</h1>');?>
        </div>
    </div>
    <div class="row">
        <div class="hidden-xs hidden-sm col-md-2"><?php dynamic_sidebar('shop-sidebar-left');?></div>
        <div class="col-xs-12 col-sm-12 col-md-8">	            
            <div class="row" id="products">
                <?php
                if ($shopLoop->have_posts()):
                    while ($shopLoop->have_posts()):$shopLoop->the_post(); ?>
                        <div class="col-xs-12 col-sm-6 col-md-4" align="center">
                            <div class="product">
                                <a class="product-link" href="<?php the_permalink(); ?>">
                                    <?php
                                    $thumbnail_attr = array(
                                        'alt' => 'product image'
                                    );
                                    the_post_thumbnail(array("180px", "180px"), $thumbnail_attr);
                                    ?>
                                    <p class="product-name"><?php the_title(); ?></p>
                                </a>
                            </div>
                        </div>
                    <?php endwhile; ?>
                <?php endif; ?>
            </div>
        </div>
        <div class="hidden-xs hidden-sm col-md-2">
            <?php dynamic_sidebar('shop-sidebar-right');?>
        </div> 
        <!--<div class='loader' hidden='true'></div>-->
        <div class='shopping-content'></div>
       
        <div class="row">
            <div class=' col-xs-12 col-md-6 col-md-offset-3' align="center">
                <button id="load-more" class="mdl-button mdl-js-button mdl-js-ripple-effect">Load More</button>
            </div>
        </div>
    </div>
</div>

