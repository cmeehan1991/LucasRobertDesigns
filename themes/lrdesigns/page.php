<?php

get_header();
if(!is_home() && is_account_page()){
	get_template_part('template-parts/page', 'account');
} else if(!is_home() && is_cart()){
	get_template_part('template-parts/page', 'cart');
}else if (!is_home() && is_checkout()){
    get_template_part('woocommerce/checkout/form', 'checkout');
}else if(is_page('about-us')){
	get_template_part('template-parts/page','about');
}

get_footer();
