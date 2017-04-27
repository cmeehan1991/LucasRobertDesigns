<?php

get_header();?>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <?php woocommerce_breadcrumb();?>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <?php the_title('<h1 align="center">','</h1>');?>
        </div>
    </div>
    <div class="row">
         <?php
            $paged = ( get_query_var('page') ) ? get_query_var('page') : 1;

            $posts_per_page = '16';
            $shopArgs = array(
                'post_type' => 'product',
                'posts_per_page' => $posts_per_page,
                'paged' => $paged,
                'orderby' => 'date',
                'order' => 'DESC'
            );


            $shopLoop = new WP_Query($shopArgs);
            ?>
            <div class="col-xs-12 col-md-12">
                <div class="row" id="products">
                    <?php
                    if ($shopLoop->have_posts()):
                        while ($shopLoop->have_posts()):$shopLoop->the_post();
                            ?>
                            <div class="col-xs-6 col-md-4" align="center">
                                <div class="product">
                                    <a class="product-link" href="<?php the_permalink(); ?>">
                                        <?php
                                        $thumbnail_attr = array(
                                            'alt' => 'product image'
                                        );
                                        the_post_thumbnail('thumbnail', $thumbnail_attr);
                                        ?>
                                        <p class="product-name"><?php the_title(); ?></p>
                                    </a>
                                </div>
                            </div>
                        <?php endwhile; ?>
                        <?php wp_reset_postdata(); ?>
                    <?php endif; ?>
                </div>
            </div> 
            <div class='loader' hidden='true'></div>
            <div class='shopping-content'></div>
           <!-- <div class='row'>
                <div class='col-md-12' align='center'>
                    <nav aria-label="Page navigation">
                        <ul class="pagination">

                        </ul>
                    </nav>
                </div>
            </div>-->
            <div class="row">
                <div class=' col-xs-12 col-md-12' align="center">
                    <button id="load-more" class="mdl-button mdl-js-button mdl-js-ripple-effect">Load More</button>
                </div>
            </div>
    </div>
</div>

