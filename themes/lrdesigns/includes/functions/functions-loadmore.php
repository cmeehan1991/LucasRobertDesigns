<?php
/*
 * This function will load more products on the page. 
 * 
 * Documentation: http://stackoverflow.com/questions/29595391/how-to-implement-pagination-on-a-custom-wp-query-ajax 
 * 
 */

function more_products_ajax() {
    $offset = filter_input(INPUT_POST, 'offset');
    $ppp = filter_input(INPUT_POST, 'ppp');
    $product_cat = filter_input(INPUT_POST, 'product_cat');
    header('Content-Type: text/html');

    $args = array(
        'post_type'      => 'product',
        'posts_per_page' => $ppp,
        'offset'         => $offset,
        'product_cat'    => $product_cat
    );
    $loop = new WP_Query($args);
    if ($loop->have_posts()) {
        while ($loop->have_posts()) {
            $loop->the_post();
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
            <?php
        }
    } else {
        echo 'no more';
    }
    die;
}

add_action('wp_ajax_more_products_ajax', 'more_products_ajax');
add_action('wp_ajax_nopriv_more_products_ajax', 'more_products_ajax');

