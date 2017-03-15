<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><?php bloginfo('title'); ?></title>
        <meta name="google-site-verification" content="T0wW8D766cKUauZI_gfftPm9_IC8Ie8_zX5pNaehrRY" />
        <?php wp_head(); ?>
    </head>
    <body>
        <div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.8";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
        <nav class="navbar">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#primary-nav" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="<?php bloginfo('url'); ?>"><?php _e(bloginfo('title'), LR_TEXTDOMAIN); ?></a>
                </div>
                <div class="collapse navbar-collapse" id="primary-nav">
                    <?php
                    $navargs = array('menu' => 'Main Navigation', 'container' => '', 'menu_class' => 'nav navbar-nav');
                    wp_nav_menu($navargs);
                    ?>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Account <span class="caret"></span></a>
                        <?php if (is_user_logged_in()) : ?>
                            <ul class="dropdown-menu">
                                <?php foreach (wc_get_account_menu_items() as $endpoint => $label) : ?>
                                    <li class="<?php echo wc_get_account_menu_item_classes($endpoint); ?>">
                                        <a href="<?php echo esc_url(wc_get_account_endpoint_url($endpoint)); ?>"><?php echo esc_html($label); ?></a>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                        <?php else: ?>
                        <ul class="dropdown-menu">
                            <li><a href="my-account">Sign In/Sign Up</a></li>
                        </ul>
                        <?php endif
                        ?></li>
                        <li><a href="cart"><i class='glyphicon glyphicon-shopping-cart'></i></a></li>
                    </ul>
                </div>
            </div>
        </nav>