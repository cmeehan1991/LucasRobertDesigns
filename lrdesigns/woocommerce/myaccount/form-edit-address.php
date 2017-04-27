<?php
/**
 * Edit address form
 *
 * This template can be overridden by copying it to yourtheme/woocommerce/myaccount/form-edit-address.php.
 *
 * HOWEVER, on occasion WooCommerce will need to update template files and you
 * (the theme developer) will need to copy the new files to your theme to
 * maintain compatibility. We try to do this as little as possible, but it does
 * happen. When this occurs the version of the template file will be bumped and
 * the readme will list any important changes.
 *
 * @see     https://docs.woocommerce.com/document/template-structure/
 * @author  WooThemes
 * @package WooCommerce/Templates
 * @version 2.6.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

$page_title = ( 'billing' === $load_address ) ? __( 'Billing address', 'woocommerce' ) : __( 'Shipping address', 'woocommerce' );

do_action( 'woocommerce_before_edit_account_address_form' ); ?>

<?php if ( ! $load_address ) : ?>
	<?php wc_get_template( 'myaccount/my-address.php' ); ?>
<?php else : ?>

	<form method="post">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-12" align="center">
					<h3><?php echo apply_filters( 'woocommerce_my_account_edit_address_title', $page_title, $load_address ); ?></h3>
				</div>
			</div>
			<div class="woocommerce-address-fields">
				<?php do_action( "woocommerce_before_edit_address_form_{$load_address}" ); ?>
	
				<div class="woocommerce-address-fields__field-wrapper">
					<?php foreach ( $address as $key => $field ) : ?>
					<div class="row">
						<div class="col-md-4 col-md-offset-5">
							
							<?php echo ($field[label] != "")? '<label for="' . $key . '">' . $field[label]. ' ' . (($field[required]) ? ':*' : '') . '</label><br/>' : '';?>
							<?php 
							if($key == "billing_country" || $key == "shipping_country"): ?>
								<script type="text/javascript">
									$(document).ready(function(){
										$('.country-select, .state-select').select2();
									});
								</script>
								<?php 
									$countries_obj = new WC_Countries();
									$countries = $countries_obj->__get('countries');
									$default_country = $countries_obj->get_base_country();
									array_unshift($countries, "Choose One");
									woocommerce_form_field($key, array(
										'type' => 'select',
										'options' => $countries,
										'required' => true,
										'input_class'=> array('country-select'),
										'default' => ($field["value"]) ? $field["value"] : "US"
									)
								);
							elseif($key == "billing_state" || $key == "shipping_state"):
								$default_country_states = $countries_obj->get_states($default_country);
								array_unshift($default_country_states, "Choose One", "N/A");
								woocommerce_form_field($key, array(
									'type' => 'select',
									'options' => $default_country_states,
									'required' => true,
									'input_class' => array('state-select'),
									'default' => ($field["value"]) ? $field["value"] : "Choose One"
								));	
							else: ?>
								<input type="text" name="<?php echo $key; ?>" value="<?php echo $field[value];?>" placeholder="<?php echo $field[placeholder]; ?>"/>
							<?php endif; ?>
						</div>
					</div>
						<?php// woocommerce_form_field( $key, $field, ! empty( $_POST[ $key ] ) ? wc_clean( $_POST[ $key ] ) : $field['value'] ); ?>
					<?php endforeach; ?>
				</div>
	
				<?php do_action( "woocommerce_after_edit_address_form_{$load_address}" ); ?>
				<div class="row">
					<div class="col-md-2 col-md-offset-5">
					<p>
						<input type="submit" class="button button__save-address" name="save_address" value="<?php esc_attr_e( 'Save address', 'woocommerce' ); ?>" />
						<?php wp_nonce_field( 'woocommerce-edit_address' ); ?>
						<input type="hidden" name="action" value="edit_address" />
					</p>
					</div>
				</div>
			</div>
		</div>
	</form>

<?php endif; ?>

<?php do_action( 'woocommerce_after_edit_account_address_form' ); ?>
