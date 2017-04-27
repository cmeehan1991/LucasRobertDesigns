<?php 
	$action = filter_input(INPUT_POST, 'action');
	switch($action){
		case "getCart": 
			getCart();
			break;
		case "add-to-cart":
			addToCart();
			break;
		case "remove-item":
			removeItemFromCart();
			break;
		case "update-item-quantity":
			updateItemQuantity();
			break;
		case "get_checkout_information":
			getCheckoutInformation();
			break;
		case "submit_order":
			submitOrder();
			break;
		case "submit_payment":
			processPayment();
			break;
		default: break;
	}
	
	function getCheckoutInformation(){
		include '../wp-load.php';
		$user_id = filter_input(INPUT_POST, 'user_id');
		
		// Array that will be echoed by the function
		$checkout_information = array();
		
		// Get the cart
		$cart_items =  WC()->cart->get_cart();
		
		// Get the user information
		// Shipping information 
		$shipping_information = array();
		$shipping_information["COMPANY_NAME"] = get_user_meta($user_id, 'company_name', true);
		$shipping_information["FIRST_NAME"] = get_user_meta($user_id, 'first_name', true);
		$shipping_information["LAST_NAME"] = get_user_meta($user_id, 'last_name', true);
		$shipping_information["STREET_ADDRESS"] = get_user_meta($user_id, 'shipping_address_1', true);
		$shipping_information["SUITE"] = get_user_meta($user_id, 'shipping_address_2', true);
		$shipping_information["CITY"] = get_user_meta($user_id, 'shipping_city', true);
		$shipping_information["STATE"] = get_user_meta($user_id, 'shipping_state', true);
		$shipping_information["POST_CODE"] = get_user_meta($user_id, 'shipping_postcode', true);

		
		// Billing information
		$billing_information = array();
		$billing_information["COMPANY_NAME"] = get_user_meta($user_id, 'company_name', true);
		$billing_information["FIRST_NAME"] = get_user_meta($user_id, 'first_name', true);
		$billing_information["LAST_NAME"] = get_user_meta($user_id, 'last_name', true);
		$billing_information["STREET_ADDRESS"] = get_user_meta($user_id, 'billing_address_1', true);
		$billing_information["SUITE"] = get_user_meta($user_id, 'billing_address_2', true);
		$billing_information["CITY"] = get_user_meta($user_id, 'billing_city', true);
		$billing_information["STATE"] = get_user_meta($user_id, 'billing_state', true);
		$billing_information["POST_CODE"] = get_user_meta($user_id, 'billing_postcode', true);
		
		
		$checkout_information["SHIPPING_NAME"] = $shipping_information["COMPANY_NAME"] . ' - ' . $shipping_information["FIRST_NAME"] . ' ' . $shipping_information["LAST_NAME"];
		
		if($shipping_information["SUITE"] != null & $shipping_information["SUITE"] != ""): 
			 $checkout_information["SHIPPING_ADDRESS"] = $shipping_information["STREET_ADDRESS"] . ', ' . $shipping_information["SUITE"] . ', ' . $shipping_information["CITY"] . ', ' . $shipping_information["STATE"] . ' ' . $shipping_information["POST_CODE"];
		else:  
			$checkout_information["SHIPPING_ADDRESS"] = $shipping_information["STREET_ADDRESS"] . ', '. $shipping_information["CITY"] . ', ' . $shipping_information["STATE"] . ' ' . $shipping_information["POST_CODE"];
		 endif; 
		$checkout_information["BILLING_NAME"] = $billing_information["COMPANY_NAME"] . ' - ' . $billing_information["FIRST_NAME"] . ' ' . $billing_information["LAST_NAME"];
		if($billing_information["SUITE"] != null & $billing_information["SUITE"] != ""): 
			 $checkout_information["BILLING_ADDRESS"] = $billing_information["STREET_ADDRESS"] . ', ' . $billing_information["SUITE"] . ', ' . $billing_information["CITY"] . ', ' . $billing_information["STATE"] . ' ' . $shipping_information["POST_CODE"];
		else:  
			$checkout_information["BILLING_ADDRESS"] = $billing_information["STREET_ADDRESS"] . ', '. $billing_information["CITY"] . ', ' . $billing_information["STATE"] . ' ' . $billing_information["POST_CODE"];
		 endif;
		 
		 //print_r($cart_items);
		 $checkout_information["ITEM_NAME"] = array();
		 $checkout_information["ITEM_SKU"] = array();
		 $checkout_information["ITEM_IMAGE_URL"] = array();
		 $checkout_information["ITEM_QUANTITY"] = array();
		 $checkout_information["ITEM_SUBTOTAL"] = array();
		  		
		foreach($cart_items as $key => $value){
			// Array to STORE all of the item information
			$item_information = array();
			$product_id = $value["product_id"];
			$product_variation_id = $value["variation_id"];
			
			$product = $value["data"];
			$item_information["ITEM_NAME"] =  $product->post->post_title;
			$item_information["ITEM_SKU"] = $product->sku;
			$item_information["ITEM_IMAGE_URL"] = get_the_post_thumbnail_url( $product_id, array('post-thumbnail'));
			$item_information["ITEM_QUANTITY"] = strval($value["quantity"]);
			$item_information["ITEM_SUBTOTAL"] = strval($value["line_subtotal"]);
			
			array_push( $checkout_information["ITEM_NAME"], $item_information["ITEM_NAME"]);
			array_push( $checkout_information["ITEM_SKU"], $item_information["ITEM_SKU"]);
			array_push( $checkout_information["ITEM_IMAGE_URL"], $item_information["ITEM_IMAGE_URL"]);
			array_push( $checkout_information["ITEM_QUANTITY"], $item_information["ITEM_QUANTITY"]);
			array_push( $checkout_information["ITEM_SUBTOTAL"], $item_information["ITEM_SUBTOTAL"]);
		}
		
		echo json_encode($checkout_information);
	}
	
	
	/*
	*
	* Here we are going to submit the order before the payment has been processed. 
	* Once the payment is processed successfully by the app then we will update the order. 
	* Now we add the items from the cart, set the user's shipping and billing information. 
	* If the payment type is paypal then we will process the paypal payment, and update the order. 
	* Otherwise the store owner will have to update the order manually once they confirm acceptance of payment type.
	* We then change the order status to 'processing'. Once the store owner has received the order and 
	* filled it then they will change it to completed. 
	* Finally we will clear the user's cart. 
	*
	*/ 
	function submitOrder(){
		include '../wp-load.php';
		
		$cart_hash = md5(json_encode(WC()->cart->get_cart_for_session()));
		$customer_id = filter_input(INPUT_POST, 'user_id');
		$payment_method = filter_input(INPUT_POST, 'payment_method');
		$cart = WC()->cart->get_cart();
		
		// Create a new order
		$args = array(
			'cart_hash' => $cart_hash, 
			'customer_id' => $customer_id
		);
		$order = wc_create_order($args);
		$order_id = $order->id;
		
		// Add the products from the user's cart to the order
		foreach($cart as $key => $value){
			if($value["variation_id"] != null && $value["variation_id"] != ""){
				$product_id = $value["variation_id"];	
			}else{
				$product_id = $value["product_id"];
			}
			$order->add_product(get_product($product_id), $value["quantity"]);
		}
		
		// Set the shipping and billing addresses
		$shipping_address_args = array(
			"company" => get_user_meta($customer_id, 'shipping_company_name', true),
			"first_name" => get_user_meta($customer_id, 'shipping_first_name', true),
			"last_name" => get_user_meta($customer_id, 'shipping_last_name', true),
			"address_1" => get_user_meta($$customer_id, 'shipping_address_1', true),
			"address_2" => get_user_meta($customer_id, 'shipping_address_2', true),
			"city" => get_user_meta($customer_id, 'shipping_city', true),
			"state" => get_user_meta($customer_id, 'shipping_state', true),
			"postcode" => get_user_meta($customer_id, 'shipping_postcode', true),
			"country" => get_user_meta($customer_id, 'shipping_country', true)
		);
		$billing_address_args = array(
			"company" => get_user_meta($customer_id, 'billing_company_name', true),
			"first_name" => get_user_meta($customer_id, 'billing_first_name', true),
			"last_name" => get_user_meta($customer_id, 'billing_last_name', true),
			"address_1" => get_user_meta($customer_id, 'billing_address_1', true),
			"address_2" => get_user_meta($customer_id, 'billing_address_2', true),
			"city" => get_user_meta($customer_id, 'billing_city', true),
			"state" => get_user_meta($customer_id, 'billing_state', true),
			"postcode" => get_user_meta($customer_id, 'billing_postcode', true),
			"country" => get_user_meta($customer_id, 'shipping_country', true), 
			"primary_phone" => get_user_meta($$customer_id, 'billing_primary_phone', true)
		);
		
		$order->set_address($shipping_address_args, 'shipping');
		$order->set_address($billing_address_args, 'billing');
		
		$order->calculate_totals();
		
		// Update the order status to pending payment. 
		// If the order is paid via paypal then the order will automatically update. 
		// Otherwise if it is not then the vendor must change it manually. 
		$order->update_status('pending payment');

		
		// Empty the cart
		WC()->cart->empty_cart();
		
		// Print a response of true in a json array to confirm the order was submitted. 
		echo json_encode(array("ORDER_SUBMITTED" => true, "ORDER_ID" => $order_id));
		
	}
	
	/*
	* If the user used paypal then this function will be executed. 
	* This function will update the user's order to reflect processing rather than 
	* pending payment. 
	*/
	function processPayment(){
		include '../wp-load.php';
		$order_id = filter_input(INPUT_POST, 'order_id');
		$order = new WC_Order($order_id);
		
		$order->update_status('processing');
		
		echo json_encode(array('ORDER_STATUS_CHANGED', true));
		
	}
	
	/*
	* This function removes an item from the user's cart. 
	* We use woocmmerce remove_cart_item() function to do this action. 
	* The woocommerce function has one required input of the cart_item_key
	*/
	function removeItemFromCart(){
		include '../wp-load.php';
		$cart_item_key = filter_input(INPUT_POST, 'cart_item_key');
		
		$remove_item = array(
			"ITEM_REMOVED" => WC()->cart->remove_cart_item($cart_item_key)
		);
		
		echo json_encode($remove_item);
	}
	
	function updateItemQuantity(){
		include '../wp-load.php';
		$quantity = filter_input(INPUT_POST, 'quantity');
		$cart_item_key = filter_input(INPUT_POST, 'cart_item_key');

		$update_quantity = array();
		$update_quantity["QUANTITY_UPDATED"] = WC()->cart->set_quantity($cart_item_key, $quantity, true);
		echo json_encode($update_quantity);
	}
	
	/**
	* This functionw will add an item to the user's cart. 
	*/
	function addToCart(){
		include '../wp-load.php';
		
		$product_id = filter_input(INPUT_POST, 'product_id');
		$quantity = filter_input(INPUT_POST, 'quantity');
		$variation_id = filter_input(INPUT_POST, 'variation_id');
		
		if(WC()->cart->add_to_cart( $product_id, $quantity, $variation_id) != null){
			echo json_encode(array("ITEM_ADDED" => true));
		}else{
			echo json_encode(array("ITEM_ADDED" => false));
		}
		
		
	}
	
	function getCart(){
		include '../wp-load.php';
		$user_id = filter_input(INPUT_POST, 'user_id');
		
		$cart_items =  WC()->cart->get_cart();
		$items_in_cart = array();
		foreach($cart_items as $cart_item_key => $cart_item){
			$item = array();
			$item["cart_item_key"] = strval($cart_item_key);
			$item["product_id"] = strval($cart_item["product_id"]);
			$item["variation_id"] = strval($cart_item["variation_id"]);
			$item["quantity"] = strval($cart_item["quantity"]);
			$item["line_subtotal"] = strval($cart_item["line_subtotal"]);
			$item["line_tax"] = strval($cart_item["line_tax"]);
			$product = $cart_item['data']->post;
			$item["name"] = $product->post_title;
			$item["item_image_url"] = get_the_post_thumbnail_url($cart_item["product_id"]);
			array_push($items_in_cart, $item);
		}
		echo json_encode($items_in_cart);		
	}