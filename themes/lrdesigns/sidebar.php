<?php
get_search_form();
$relatedProducts = array(
    'posts_per_page' => 4,
    'columns' => 1,
    'orderby' => 'rand'
);
woocommerce_related_products($relatedProducts);
