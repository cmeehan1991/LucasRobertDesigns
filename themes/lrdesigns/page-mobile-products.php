<?php
// Silence is golden

$action = 'get products';//filter_input(INPUT_POST, 'action');

switch($action){
    case 'get products':
        get_products();
        break;
    default:break;
}

function get_products(){
    $page = filter_input(INPUT_POST, 'page');
    $ppp = filter_input(INPUT_POST, 'ppp');
    $offset = ($page - 1) * $ppp;
    
    $loop_args = array('post_type'=>'product','posts_per_page'=>$ppp, 'offset'=>$offset);
    $loop = new WP_Query($loop_args);
    
    if($loop->have_posts()):
        $results = array();
        while ($loop->have_posts()){ $loop->the_post();
            $result['product_name'] = get_the_title();
            $result['image_url'] = get_the_post_thumbnail_url();
            $result['item_id'] = get_the_ID();
            $product = wc_get_product();
            $result['price'] = $product->get_price();
            array_push($results, $result);
        }
        echo json_encode($results);
    endif;
}


