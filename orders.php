<?php 
	include '../wp-load.php';
	
	
	$user_id = filter_input(INPUT_POST, 'user_id');
	$action =  filter_input(INPUT_POST, 'action');
	
	/*
	* Filter the status based on the action type
	*/
	switch($action){
		case 'summary-cancelled':
			$status = array('wc-cancelled');
			get_order($status, $user_id, 5);
			break;
		case 'summary-completed': 
			$status = array('wc-completed');
			get_order($status, $user_id, 10);
			break;
		case 'summary-pending':
			$status = array('wc-pending','wc-on-hold','wc-processing');
			get_order($status, $user_id, 10);
			break;
		case 'summary-recent':
			$status = array('wc-completed', 'wc-cancelled');
			get_order($status, $user_id, 10);
			break;
		case 'view-order':
			view_order();
			break;
		case 'order-get-item':
			view_item();
			break;
		default: break;
	}
	
	/*
	* This function will retrieve an individual item selected from an order.
	* It will echo an associative array in json format.
	*/
	function view_item(){
		$item_id = filter_input(INPUT_POST, 'item_id');
		$order_id = filter_input(INPUT_POST, 'order_id');
		
		// Get the product & order from woocommerce
		$product = wc_get_product($item_id);
		$order = wc_get_order($order_id);
		$items = $order->get_items();
		
		// Array that will store the product data
		$product_info = array();
		$product_info["ITEM_NAME"] = $product->name;
		$product_info["ITEM_IMAGE_URL"] = get_the_post_thumbnail_url($item_id);
		$product_info["ITEM_SKU"] = $product->sku;
		$product_info["ORDER_DATE"] = date('M d, Y', strtotime($order->order_date));
		$product_info["ORDER_STATUS"] = $order->status;
		foreach($items as $item){
			if($item["product_id"] == $item_id){
				$product_info["ORDER_QUANTITY"] = strval($item["qty"]);
			}
		}
		
		echo json_encode($product_info);
	}
	
	/*
	* This function will retrieve an order and return the information as json. 
	* The data returned will be the order status, item(s) image(s), item(s) name(s), quantity ordered, and the sku(s).
	*/
	function view_order(){
		$order_id = filter_input(INPUT_POST, 'order_id');
		
		$order = wc_get_order($order_id);
		$order_information = array();
		$order_information['STATUS'] = $order->status;
		$order_information['ITEM_ID'] = array();
		$order_information['ITEM_NAME'] = array();
		$order_information['ITEM_IMAGE_URL'] = array();
		$order_information['ITEM_QTY'] = array();
		$order_information['ITEM_SKU'] = array();
		
		$items = $order->get_items();	
			
		foreach($items as $item){
			array_push($order_information['ITEM_ID'], $item['product_id']);
			array_push($order_information['ITEM_NAME'], $item["name"]);
			array_push($order_information['ITEM_IMAGE_URL'], get_the_post_thumbnail_url($item["product_id"], 'post-thumbnail'));
			array_push($order_information['ITEM_QTY'], strval($item["qty"]));
			
			$product = new WC_Product($item["product_id"]);
			array_push($order_information["ITEM_SKU"], $product->get_sku());
		}
		echo json_encode(array($order_information));
	}
	
	/*
	* Get the orders based on the status and the user id. 
	* 
	* Order Status Options: wc-pending, wc-processing, wc-on-hold, wc-completed, wc-cancelled, wc-refunded, wc-failed
	*
	* @params $status array, $user_id string
	*
	*/
	
	function get_order($status, $user_id, $limit){
		
		$order_args = array(
			'status' 	=> 	$status,
			'customer' 	=> 	$user_id,
			'limit' 	=>  $limit,
			'orderby' 	=>  'date',
			'order'		=>  'desc'
		);
		
		$orders = wc_get_orders($order_args);
			
		$order_array = array();
		
		foreach($orders as $order){
			$order_details = array();
			$order_details["ID"] = strval($order->id);
			$order_details["ORDER_STATUS"] = $order->status;
			$order_details["ORDER_DATE"] = date('M d, Y', strtotime($order->order_date));
			$items = $order->get_items();
			$order_details["ITEM_NAMES"] = array();
			$order_details["ITEM_IDs"] = array();
			foreach($items as $item){
				array_push($order_details["ITEM_NAMES"], $item["name"]);
				array_push($order_details["ITEM_IDs"], $item["product_id"]);
			}			
			array_push($order_array, $order_details);
		}
		echo json_encode($order_array);
	}

		