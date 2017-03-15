<?php 
	function lrdesigns_widget_init(){
		register_sidebar(array(
			'name'          => __('Default Sidebar', LR_TEXTDOMAIN),
			'id'            => 'default-sidebar',
			'before_widget' => '<ul class="default-sidebar">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
		register_sidebar(array(
			'name'          => __('Shop Sidebar', LR_TEXTDOMAIN),
			'id'            => 'shop-sidebar',
			'before_widget' => '<ul class="shop-sidebar">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
		register_sidebar(array(
			'name'          => __('Cart Sidebar', LR_TEXTDOMAIN),
			'id'            => 'cart-sidebar',
			'before_widget' => '<ul class="cart-sidebar">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
	}
	
	add_action('widgets_init', 'lrdesigns_widget_init');