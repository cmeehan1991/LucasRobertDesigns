<?php
get_header();
?>
<div class="container-fluid">
    <div class='row'>
        <div class="jumbotron">
            <img src='http://wpdev.lucasrobertdesigns.com/wp-content/themes/lrdesigns/images/Signature Banner.png' alt='banner' width='100%' height='50%'/>
        </div>
    </div>
    <div class="main">
        <div class="row">
            <div class="col-md-12" align="center">
                <h2>Featured Items</h2>
            </div>
        </div>
        <div class="row">
            <?php
            $indexArgs = array(
                'post_type' => 'product',
                'meta_key' => '_featured',
                'meta_value' => 'yes',
                'posts_per_page' => 4
            );
            $indexLoop = new WP_Query($indexArgs);
            if ($indexLoop->have_posts()):
                while ($indexLoop->have_posts()):$indexLoop->the_post();
                    ?>
                    <div class="col-xs-6 col-sm-4 col-md-3" align="center">
                        <div class="product">
                            <a class="product-link" href="<?php the_permalink(); ?>">
                                <img src="<?php the_post_thumbnail_url('thumbnail'); ?>" alt="Product Image"/>
                                <p class="product-name"><?php the_title(); ?></p>
                            </a>
                        </div>
                    </div>
                <?php endwhile; ?>
            <?php else: ?>
                There are no featured products
            <?php endif; ?>
        </div>
    </div>
    <div class="odd-row">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xs-6 col-md-2 col-md-offset-2">
                    <h3 align="center"> Design</h3>
                    <p align="center">Each piece is custom designed.<br/>All designs are unique and 100% original.</p>
                </div>
                <div class="col-xs-6 col-md-2">
                    <h3 align="center">Quality</h3>
                    <p align="center">Highest quality freshwater pearls.<br/>Top of the line precious stones.<br/>Fine sterling silver.</p>
                </div>
                <div class="col-xs-6 col-md-2">
                    <h3 align="center">Elegance</h3>
                    <p align="center">Designed for ultimate beauty.<br/>Unparalled luxury.<br/>Modern class.</p>
                </div>
                <div class="col-xs-6 col-md-2">
                    <h3 align="center">Unique</h3>
                    <p align="center">No two pearls are the same.<br/>Each pearl and precious stone is hand picked from the finest lots.<br/>Each design shouts originality.</p>
                </div>
            </div>
        </div>
    </div>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12" align="center">
                <h2 >Created for Show - Designed for Class</h2>
                <img src='<?php _e(BLOG_URI, LR_TEXTDOMAIN); ?>/images/LR-105.jpg' width="300px" height="300px" alt='LR-105'/>
            </div>
        </div>
    </div>
    <div class="odd-row">
        <div class="container-fluid">    
            <div class="row">
                <h3 align="center">Purchase from one of our fine retailers.</h3>
            </div>
            <div class="row">
                <div class="col-xs-12 col-md-12" align="center">
                    <p>Lucas Robert Designs' products can be purchased through one of our many fine retailers.<br/>We have ### amazing retailers across the United States.<br/>To locate a retailer, simply follow the link below, or <a href='mailto:lucasrobert2004@aol.com'>email</a> us.<br/><a href="">Locate a retailer</a></p>
                </div>
            </div>
        </div>
    </div>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <h3 align="center">Becoming a retailer</h3>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-6 col-md-4" align="center">
                <h4>1. Contact a Rep</h4>
                <p><a href="mailto:someone@me.com">Email</a> us to get connected to your regional rep.<br/>Browse our store while you&apos;re waiting.<br/>It won&apos;t take long. We always respond within 72 hours.</p>
            </div>
            <div class="col-xs-6 col-md-4"align="center">
                <h4>2. Get Signed Up</h4>
                <p>Our rep will help you to create your account.<br/>Once your account has been created you can start purchasing either online or through your assigned rep.</p>
            </div>
            <div class="col-xs-12 col-md-4"align="center">
                <h4>3. Start Ordering</h4>
                <p>You can start ordering new products as soon as you have been signed up through a rep.<br/>Normally orders are shipped within 72 hours.</p>
            </div>
        </div>
    </div>
</div>
<?php
get_footer();
