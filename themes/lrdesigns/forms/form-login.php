<?php
/**
 * Login Form
 *
 * This template can be overridden by copying it to yourtheme/woocommerce/myaccount/form-login.php.
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
if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly
}
?>

<?php wc_print_notices(); ?>

<?php do_action('woocommerce_before_customer_login_form'); ?>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 col-md-offset-5">

            <h2 align="center"><?php _e('Login', LR_TEXTDOMAIN); ?></h2>

            <form method="post" class="login">

                <?php do_action('woocommerce_login_form_start'); ?>

                <p class="woocommerce-FormRow woocommerce-FormRow--wide form-row form-row-wide">
                    <label for="username"><?php _e('Username or email address', LR_TEXTDOMAIN); ?> <span class="required">*</span></label><br />
                    <input type="text" class="woocommerce-Input woocommerce-Input--text input-text" name="username" id="username" value="<?php if (!empty($_POST['username'])) echo esc_attr($_POST['username']); ?>" />
                </p>
                <p class="woocommerce-FormRow woocommerce-FormRow--wide form-row form-row-wide">
                    <label for="password"><?php _e('Password', 'woocommerce'); ?> <span class="required">*</span></label><br/>
                    <input class="woocommerce-Input woocommerce-Input--text input-text" type="password" name="password" id="password" />
                </p>

                <?php do_action('woocommerce_login_form'); ?>

                <p class="form-row">
                    <?php wp_nonce_field('woocommerce-login', 'woocommerce-login-nonce'); ?>
                    <input type="submit" class="woocommerce-Button button" name="login" value="<?php esc_attr_e('Login', 'woocommerce'); ?>" />
                    <label for="rememberme" class="inline">
                        <input class="woocommerce-Input woocommerce-Input--checkbox" name="rememberme" type="checkbox" id="rememberme" value="forever" /> <?php _e('Remember me', 'woocommerce'); ?>
                    </label>
                </p>
                <p class="woocommerce-LostPassword lost_password">
                    <a href="<?php echo esc_url(wp_lostpassword_url()); ?>"><?php _e('Lost your password?', 'woocommerce'); ?></a>
                </p>

                <?php do_action('woocommerce_login_form_end'); ?>

            </form>

            <?php if (get_option('woocommerce_enable_myaccount_registration') === 'yes') : ?>

            </div>
        <?php endif; ?>

        <?php do_action('woocommerce_after_customer_login_form'); ?>

    </div>
</div>
