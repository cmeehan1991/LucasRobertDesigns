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
			'name'          => __('Shop Sidebar: Left', LR_TEXTDOMAIN),
			'id'            => 'shop-sidebar-left',
			'before_widget' => '<ul class="shop-sidebar-left">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
		register_sidebar(array(
			'name'          => __('Shop Sidebar: Right', LR_TEXTDOMAIN),
			'id'            => 'shop-sidebar-right',
			'before_widget' => '<ul class="shop-sidebar-right">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
		register_sidebar(array(
			'name'          => __('Product Sidebar: Left', LR_TEXTDOMAIN),
			'id'            => 'product-sidebar-left',
			'before_widget' => '<ul class="product-sidebar-left">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
		register_sidebar(array(
			'name'          => __('Product Sidebar: Right', LR_TEXTDOMAIN),
			'id'            => 'product-sidebar-right',
			'before_widget' => '<ul class="product-sidebar-right">',
			'after_wideget' => '</ul>',
			'before_title'  => '<h3 class="widget-title">',
			'after_title'   => '</h3>'
		));
	}
	
	add_action('widgets_init', 'lrdesigns_widget_init');