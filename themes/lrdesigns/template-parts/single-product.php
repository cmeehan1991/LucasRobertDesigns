<div class="container-fluid">
<?php $product = wc_get_product(get_the_ID());?>
	
    <div class="row">
        <?php while (have_posts()):the_post(); ?>
            <?php the_content(); ?>
            <div class="col-md-6" id="product-image" align="right">
	                <?php $attachment_ids = $product->get_gallery_attachment_ids(); ?>
	                <ul class="product-gallery">
		             <?php 
		                foreach($attachment_ids as $attachment_id){
			                echo "<li><a href='" . wp_get_attachment_image_src($attachment_id, 'large')[0] . "' class='zoom first' data-rel='prettyPhoto[product-gallery]'><img src='" . wp_get_attachment_image_src( $attachment_id, 'large')[0] . "' /></li></a>";
		                }
                	?>
	                </ul>
            </div>
            <div class="col-md-6">
                <?php $product = wc_get_product(get_the_ID()); //new WC_Product(get_the_ID()); ?>
                <?php the_title('<h1>', '</h1>'); ?>

                <?php
                $the_product = wc_get_product(get_the_ID());
                ?>
                <table class="product-information">
                    <tr>
                        <?php if ($product->is_type('variable')): ?>
                            <td><b>Lengths: </b>
                            <?php $variations = $product->get_available_variations(); ?>
                                <?php 
                                $vars = "";
                                $count = 0;
                                foreach ($variations as &$variation): 
                                    $count++; 
                                    $vars .= $variation['attributes']['attribute_length']; 
                                endforeach; 
                                echo $variations[0]['attributes']['attribute_length'];
                                for($i = 1; $i < $count; $i++){
                                    echo ' or '.$variations[$i]['attributes']['attribute_length'];
                                }
                                ?>
                            </td>
                            <td>
                                <b>MSRP:</b>
                                <?php 
                                $prices = $product->get_available_variations();
                                $vars = "";
                                $count = 0;
                                foreach($prices as $price){
                                    $vars .= $prices[$count]['display_regular_price'];
                                    $count++;
                                }
                                echo '$' .  number_format($prices[0]['display_regular_price'] * 2.5, 2);
                                for ($i = 1; $i < $count; $i++){
                                    echo ' or $' . number_format($prices[$i]['display_regular_price'] * 2.5, 2);
                                }
                                ?>
                            </td>
                        <?php else: ?>
                            <td colspan="2" class="product-information__msrp">
                                <b>MSRP: </b>$<?php echo number_format(doubleval($product->get_price()) * 2.5, 2); ?>
                            </td>
                        <?php endif; ?>
                    </tr>
                    <tr>
                        <td class="product-information__sku">
                            <b>SKU: </b> <?php echo $product->get_sku(); ?> 
                        </td>
                        <td class="product-information__category">
                            <b>Category: </b> <?php echo $product->get_categories(); ?>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <script>

                </script>
                <ul class="tab">
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Reviews')" id="defaultOpen"><?php _e("Reviews " . $product->get_review_count(), LR_TEXTDOMAIN); ?></a></li>
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Description')"><?php _e("Description", LR_TEXTDOMAIN); ?></a></li>
                    <?php if (is_user_logged_in()): ?>
                        <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Purchase')"><?php _e('Purchase', LR_TEXTDOMAIN); ?></a></li>
                    <?php endif; ?>
                </ul>
                <div id="Reviews" class="tabcontent">
                    <?php
                    if (comments_open()) {
                        comments_template('', true);
                    } else {
                        _e('<h3>Reviews are not open for this item</h3>', LR_TEXTDOMAIN);
                    }
                    ?>
                </div>
                <div id="Description" class="tabcontent">
                    <?php _e($product->get_title()); ?>
                </div>
                <div id="Purchase" class="tabcontent">
                    <h3>Add <?php _e($product->get_title(), LR_TEXTDOMAIN); ?> to Your Cart</h3> 
                    <?php if ($product->is_in_stock()): ?>
                        <?php if ($product->get_type() == 'variable'): ?>
                            <?php echo woocommerce_variable_add_to_cart(); ?>
                        <?php elseif($product->get_type() == 'simple'): ?>
                            <?php echo woocommerce_simple_add_to_cart(); ?>
                        <?php endif; ?>
                    <?php else: ?>
                        <p>This item is currently out of stock.</p>
                    <?php endif; ?>
                </div>
            </div>
        <?php endwhile; ?>  
    </div>
</div>