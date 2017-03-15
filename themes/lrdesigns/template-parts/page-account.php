<?php get_header(); ?>

<?php if (is_user_logged_in()): ?>
<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12 col-md-2" id="account-navigation">
            <h3><?php _e("Navigation", LR_TEXTDOMAIN);?></h3>
            <?php woocommerce_account_navigation();?>
        </div>
        <div class='col-xs-12 col-md-10'>
            <?php woocommerce_account_content();?>
        </div>
    </div>
</div>


<?php else:get_template_part('forms/form','login') ?>

<?php endif; ?>

<?php get_footer(); ?>