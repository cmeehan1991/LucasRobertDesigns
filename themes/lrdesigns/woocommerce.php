<?php

get_header();

if (!is_home() && is_shop()):
    get_template_part('template-parts/page', 'shop');
elseif (!is_home() && is_product_category()):
	get_template_part('template-parts/page','categories');
elseif (!is_home() && is_product()):
    get_template_part('template-parts/page', 'product');
elseif (!is_home() && is_cart()):
    get_template_part('template-parts/page', 'cart');
elseif (!is_home() && is_account_page()):
	echo "<script>window.alert('hello, world');</script>";
    get_template_part('template-parts/page', 'account');
elseif (!is_home() && is_checkout()):
    get_template_part('woocommerce/checkout/form', 'checkout');
else:
	_e("No solution");
endif;

get_footer();
