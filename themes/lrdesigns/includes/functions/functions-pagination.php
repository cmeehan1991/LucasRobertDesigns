<?php

function num_pages_ajax() {
    echo ceil((wp_count_posts('product')->publish) / 15);
    die;
}

add_action('wp_ajax_num_pages_ajax', 'num_pages_ajax');
add_action('wp_ajax_nopriv_num_pages_ajax', 'num_pages_ajax');

function go_to_page_ajax() {
    $page = filter_input(INPUT_POST, 'page');

    $offset = $page * 15;

    $paged = ( get_query_var('page') ) ? get_query_var('page') : 1;
    $args = array(
        'post_type' => 'product',
        'offset' => $offset,
        'posts_per_page' => '16',
        'paged' => $paged,
        'orderby' => 'date',
        'order' => 'DESC'
    );

    $loop = new WP_Query($args);
    if ($loop->have_posts()):
        while ($loop->have_posts()): $loop->the_post();
            ?>
            <div class="col-xs-6 col-md-3" align="center">
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
        endwhile;
    endif;
    die;
}

add_action('wp_ajax_go_to_page_ajax', 'go_to_page_ajax');
add_action('wp_ajax_nopriv_go_to_page_ajax', 'go_to_page_ajax');

