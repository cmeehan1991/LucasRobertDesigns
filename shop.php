<?php 
	
	$ppp = 10;
	$action = filter_input(INPUT_POST, 'action');
	switch($action){
		case 'get_products':
			getProducts();
			break;
		case 'viewProducts':
			viewProduct();
			break;
		case "addToCart":
			addItemToCart();
			break;
		default:
			break;		
	}
	
	function viewProduct(){
		// Load wordpress
		include '../wp-load.php';
		
		// Get the product ID to query the product information
		$product_id = filter_input(INPUT_POST, 'product_id');
		$product_type= filter_input(INPUT_POST, 'product_type');
		
		// Get the product from woocommerce
		$product = wc_get_product($product_id);
		
		// Get the attachment IDs in order to retrieve the image URLs
		$attachment_ids = $product->get_gallery_attachment_ids();
		$image_urls = array();
		foreach($attachment_ids as $attachment_id){
			array_push($image_urls, wp_get_attachment_image_url($attachment_id, 'large'));
		}
		
		// An array to store the product information
		$product_information = array();
		$product_information["DESCRIPTION"] = $product->short_description;
		$product_information["IMAGE_URLS"] = $image_urls;
		$product_information["VARIATION_ID"] = array();
		$product_information["VARIATION_LENGTHS"] = array();
		$product_information["VARIATION_PRICES"] = array();
		if($product_type == "variable"){
			$variations = $product->get_available_variations();
			foreach($variations as $variation){
				$sanitized_length = str_replace('"', "", stripslashes($variation["attributes"]["attribute_lengths"]));
				array_push($product_information["VARIATION_ID"], (string)$variation["id"]);
				array_push($product_information["VARIATION_LENGTHS"], $sanitized_length);
				array_push($product_information["VARIATION_PRICES"], (string)$variation["display_price"]);
			}
		}else if($product_type == "simple"){
			$product_information["ITEM_PRICES"] = $product->get_price();
		}
		
		echo json_encode($product_information);
		
	}
	
	function getProducts(){
		// Load wordpress
		include '../wp-load.php';
		
		global $ppp;
		
		// Get the product category for which we are looking for and set up the query;
		$product_category = filter_input(INPUT_POST, 'product_category');
		$ppp = $ppp;
		$offset = filter_input(INPUT_POST, 'offset');
		
		$args = array(
		'post_type' => 'product',
		'posts_per_page' => $ppp,
		'orderby' => 'date',
		'product_cat'=>$product_category,
		'order' => 'DESC',
	    'meta_query' => array(array('key'=>'_thumbnail_id')),
	    'offset' => $offset
		);
		
		$loop = new WP_Query($args);
		
		$results = array();
		
		if($loop->have_posts()){
			while($loop->have_posts()){
				$loop->the_post();
				$thumbnail_attr = array('alt' => 'product image');
				$product = wc_get_product(get_the_id());
				
				$item = array();
				$item["ITEM_ID"] = get_the_id();
				$item["ITEM_NAME"] = get_the_title();
				$item["ITEM_IMAGE_URL"] = get_the_post_thumbnail_url();
				if($product->is_type('variable')){
					$item["ITEM_TYPE"] = "variable";
					$variations = $product->get_available_variations();
					$item["ITEM_PRICE"] = array();
					foreach($variations as $variation){
						array_push($item["ITEM_PRICE"], $variation['display_regular_price']);
					}
				}else{
					$item["ITEM_TYPE"] = "simple";
					$item["ITEM_PRICE"] = $product->get_price();
				}
				
				
				array_push($results, $item);
			}
		}
		
		echo json_encode($results);
		die();
		
	}