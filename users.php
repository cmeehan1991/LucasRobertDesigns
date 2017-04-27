<?php
	include '../wp-load.php';
	$action = filter_input(INPUT_POST, 'action');
	
	switch($action){
		case 'log in':
			userSignIn();
			break;
		case 'check_user_status':
			isUserSignedIn();
			break;
		case 'userLogOut': 
			userLogOut();
			break;
		case 'get_billing_information':
			getBillingInformation();
			break;
		case 'get_shipping_information':
			getShippingInformation();
			break;
		case 'updateShippingInformation':
			setShippingInformation();
			break;
		case 'updateBillingInformation':
			setBillingInformation();
			break;
		default:
			break;
	}
	
	function getBillingInformation(){
		$user_id = filter_input(INPUT_POST, 'user_id');
		
		$billing_information = array();
		$billing_information["COMPANY_NAME"] = get_user_meta($user_id, 'billing_company', true);
		$billing_information["FIRST_NAME"] = get_user_meta($user_id, 'billing_first_name', true);
		$billing_information["LAST_NAME"] = get_user_meta($user_id, 'billing_last_name', true);
		$billing_information["STREET_ADDRESS"] = get_user_meta($user_id, 'billing_address_1', true);
		$billing_information["SUITE"] = get_user_meta($user_id, 'billing_address_2', true);
		$billing_information["CITY"] = get_user_meta($user_id, 'billing_city', true);
		$billing_information["STATE"] = get_user_meta($user_id, 'billing_state', true);
		$billing_information["POST_CODE"] = get_user_meta($user_id, 'billing_postcode', true);
		$billing_information["PRIMARY_PHONE"] = get_user_meta($user_id, 'billing_primary_phone', true);
		$billing_information["FAX"] = get_user_meta($user_id, 'billing_fax', true);
		
		echo json_encode($billing_information);
	}
	
	function getShippingInformation(){
		
		$user_id = filter_input(INPUT_POST, 'user_id');
		
		$shipping_information = array();
		$shipping_information["COMPANY_NAME"] = get_user_meta($user_id, 'shipping_company', true);
		$shipping_information["FIRST_NAME"] = get_user_meta($user_id, 'shipping_first_name', true);
		$shipping_information["LAST_NAME"] = get_user_meta($user_id, 'shipping_last_name', true);
		$shipping_information["STREET_ADDRESS"] = get_user_meta($user_id, 'shipping_address_1', true);
		$shipping_information["SUITE"] = get_user_meta($user_id, 'shipping_address_2', true);
		$shipping_information["CITY"] = get_user_meta($user_id, 'shipping_city', true);
		$shipping_information["STATE"] = get_user_meta($user_id, 'shipping_state', true);
		$shipping_information["POST_CODE"] = get_user_meta($user_id, 'shipping_postcode', true);
		$shipping_information["PRIMARY_PHONE"] = get_user_meta($user_id, 'shipping_primary_phone', true);
		$shipping_information["FAX"] = get_user_meta($user_id, 'shipping_fax', true);
		
		echo json_encode($shipping_information);
	}
	
	function setBillingInformation(){
		$user_id = filter_input(INPUT_POST, 'user_id');
		$company_name = filter_input(INPUT_POST, 'company_name');
		$first_name = filter_input(INPUT_POST, 'first_name');
		$last_name = filter_input(INPUT_POST, 'last_name');
		$street_address = filter_input(INPUT_POST, 'street_address');
		$suite = filter_input(INPUT_POST, 'suite');
		$city = filter_input(INPUT_POST, 'city');
		$state = filter_input(INPUT_POST, 'state');
		$zip = filter_input(INPUT_POST, 'zip');
		$phone = filter_input(INPUT_POST, 'phone');
		$fax = filter_input(INPUT_POST, 'fax');
		
		$update_meta = array();
		
		array_push($update_meta, update_user_meta($user_id, 'billing_company', $company_name));
		array_push($update_meta, update_user_meta($user_id, 'billing_first_name', $first_name));
		array_push($update_meta, update_user_meta($user_id, 'billing_last_name', $last_name));
		array_push($update_meta, update_user_meta($user_id, 'billing_address_1', $street_address));
		array_push($update_meta, update_user_meta($user_id, 'billing_address_2', $suite));
		array_push($update_meta, update_user_meta($user_id, 'billing_city', $city));
		array_push($update_meta, update_user_meta($user_id, 'billing_state', $state));
		array_push($update_meta, update_user_meta($user_id, 'billing_postcode', $zip));
		array_push($update_meta, update_user_meta($user_id, 'billing_primary_phone', $phone));
		array_push($update_meta, update_user_meta($user_id, 'billing_fax', $fax));
		
		$update = true; 
		
		foreach($update_meta as $meta){
			if($meta == false){
				$update = false;
			}
		}
		
		echo json_encode(array("UPDATED"=>$update));
	}
	
	function setShippingInformation(){
		$user_id = filter_input(INPUT_POST, 'user_id');
		$company_name = filter_input(INPUT_POST, 'company_name');
		$first_name = filter_input(INPUT_POST, 'first_name');
		$last_name = filter_input(INPUT_POST, 'last_name');
		$street_address = filter_input(INPUT_POST, 'street_address');
		$suite = filter_input(INPUT_POST, 'suite');
		$city = filter_input(INPUT_POST, 'city');
		$state = filter_input(INPUT_POST, 'state');
		$zip = filter_input(INPUT_POST, 'zip');
		$phone = filter_input(INPUT_POST, 'phone');
		$fax = filter_input(INPUT_POST, 'fax');
		
		$update_meta = array();
		
		array_push($update_meta, update_user_meta($user_id, 'shipping_company', $company_name));
		array_push($update_meta, update_user_meta($user_id, 'shipping_first_name', $first_name));
		array_push($update_meta, update_user_meta($user_id, 'shipping_last_name', $last_name));
		array_push($update_meta, update_user_meta($user_id, 'shipping_address_1', $street_address));
		array_push($update_meta, update_user_meta($user_id, 'shipping_address_2', $suite));
		array_push($update_meta, update_user_meta($user_id, 'shipping_city', $city));
		array_push($update_meta, update_user_meta($user_id, 'shipping_state', $state));
		array_push($update_meta, update_user_meta($user_id, 'shipping_postcode', $zip));
		array_push($update_meta, update_user_meta($user_id, 'shipping_primary_phone', $phone));
		array_push($update_meta, update_user_meta($user_id, 'shipping_fax', $fax));
		
				
		$update = true; 
		
		foreach($update_meta as $meta){
			if($meta == false && $meta != "" && $meta != null){
				$update = false;
			}
		}
		
		echo json_encode(array("UPDATED"=>$update));
	}
	
	/*
	* This function checks if the user is currently signed in. 
	*/ 
	function isUserSignedIn(){
		include '../wp-load.php';
		$user = array();
		if(is_user_logged_in()){
			$user['STATUS'] = is_user_logged_in();
			$user['USER_ID'] = strval(get_current_user_id());
		}else{
			$user['STATUS'] = false;
			$user['USER_ID'] = "";
		}
		
		echo json_encode($user);
	}
	
	function userSignIn(){
		include '../wp-load.php';
		$username = filter_input(INPUT_POST, 'username');
		$password = filter_input(INPUT_POST, 'password');
		
		$creds = array(
			'user_login' => $username,
			'user_password' => $password,
			'remember' => true
		);
		
		$user = wp_signon($creds, false);
		
		if(is_wp_error($user)){
			$user_information = array(
				'ERROR' => $user->get_error_message(),
				'USER_ID' => '',
				'ROLES' => '',
				'EMAIL' => '',
				'DISPLAY_NAME' => ''
			);

		}else{
			$user_information = array(
				'ERROR' => 'NONE',
				'USER_ID' => strval($user->ID),
				'ROLES' => $user->roles,
				'EMAIL' => $user->user_email,
				'DISPLAY_NAME' => $user->display_name
			);
		}
		echo json_encode($user_information);
	}
	
	function userLogOut(){
		wp_logout();
	}
	