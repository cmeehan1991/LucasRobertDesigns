<?php
/**
 * My Account Dashboard
 *
 * Shows the first intro screen on the account dashboard.
 *
 * This template can be overridden by copying it to yourtheme/woocommerce/myaccount/dashboard.php.
 *
 * HOWEVER, on occasion WooCommerce will need to update template files and you
 * (the theme developer) will need to copy the new files to your theme to
 * maintain compatibility. We try to do this as little as possible, but it does
 * happen. When this occurs the version of the template file will be bumped and
 * the readme will list any important changes.
 *
 * @see         https://docs.woocommerce.com/document/template-structure/
 * @author      WooThemes
 * @package     WooCommerce/Templates
 * @version     2.6.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly
}
include_once(WP_PLUGIN_DIR . '/woocommerce/includes/admin/reports/class-wc-admin-report.php');
/*
* Order status options: 
* wc-pending
* wc-processing
* wc-on-hold
* wc-completed 
* wc-cancelled
* wc-refunded
* wc-failed
*/

$completed_month_args = array(
	'status' 		=> 	array('wc-completed'),
	'customer' 		=> 	get_current_user_id(),
	'date_before' 	=> date('t-m-Y'),
	'date_after' 	=> date('1-m-Y'),
);

$completed_month_count = count(wc_get_orders($completed_month_args));

$processing_args = array(
	'status' 		=> 	array('wc-pending', 'wc-processing', 'wc-on-hold'),
	'customer' 		=> 	get_current_user_id()
);

$processing_count = count(wc_get_orders($processing_args));


?>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12 account-summary">
			<div class="row">
				<div class="col-md-2 account-summary__display-name">
					<span><?php echo $current_user->display_name; ?> <br/>Account Summary</span><p>Not <?php _e($current_user->display_name, LR_TEXTDOMAIN);?>? <a href="<?php esc_url( wc_logout_url( wc_get_page_permalink( 'myaccount' ) ) ); ?>">Sign Out</a></p>
				</div>
				<div class="col-md-2 account-summary__recent-order-count">
					<p>Current Orders* <br/>
					<strong><?php echo $processing_count;?></strong><br/>
					<a href="<?php echo esc_url(wc_get_endpoint_url('orders')); ?>">View More</a></p>
				</div>
			</div>
		</div>
	</div>	
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="col-md-6 dashboard-navigation__main"><i class="fa fa-map-marker" aria-hidden="true'"></i><a href="<?php echo esc_url(wc_get_endpoint_url('edit-address')); ?>">Shipping &amp; Billing Address</a></div>
			<div class="col-md-6 dashboard-navigation__main"><i class="fa fa-truck" aria-hidden="true'"></i><a href="<?php echo esc_url(wc_get_endpoint_url('orders')); ?>">Your Orders</a></div>
			<div class="col-md-6 dashboard-navigation__main"><i class="fa fa-shopping-cart" aria-hidden="true'"></i><a href="<?php echo esc_url(wc_get_endpoint_url('cart')); ?>">Your Cart</a></div>
			<div class="col-md-6 dashboard-navigation__main"><i class="fa fa-key" aria-hidden="true'"></i><a href="<?php echo esc_url(wc_get_endpoint_url('edit-account')); ?>">Account Details</a></div>
		</div>
	</div>
</div>

<?php
	/**
	 * My Account dashboard.
	 *
	 * @since 2.6.0
	 */
	do_action( 'woocommerce_account_dashboard' );

	/**
	 * Deprecated woocommerce_before_my_account action.
	 *
	 * @deprecated 2.6.0
	 */
	do_action( 'woocommerce_before_my_account' );

	/**
	 * Deprecated woocommerce_after_my_account action.
	 *
	 * @deprecated 2.6.0
	 */
	do_action( 'woocommerce_after_my_account' );

/* Omit closing PHP tag at the end of PHP files to avoid "headers already sent" issues. */
