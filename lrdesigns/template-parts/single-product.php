<div class="container-fluid">
<?php $product = wc_get_product(get_the_ID());?>


	
    <div class="row">
        <?php while (have_posts()):the_post(); ?>
            <?php the_content(); ?>
            <div class="col-md-6" id="product-image">
				<?php do_action( 'woocommerce_before_single_product_summary' ); ?>
				<?php $attachment_ids = $product->get_gallery_image_ids(); ?>
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
                        <script type="text/javascript">
	                        $(document).ready(function(){
	                        	$('.product-variation-select').select2({
		                        	width:"fit-content",
		                        	placeholder: "Variations"
	                        	});
	                        });
                        </script>
                            <td colspan="2">
	                            <label for="lengths">Item Variations</label>
	                            <select name="lengths" class="product-variation-select" id="lengths" style="width:100px;">
                            <?php 
	                            $variations = $product->get_available_variations(); 
                                $vars = "";
                                $count = 0;
                                foreach ($variations as &$variation): 
                                    $count++; 
                                    $vars = $variation['attributes']['attribute_lengths']; 
                                    $prices = (is_user_logged_in()) ? number_format($variation['display_regular_price'], 2) : number_format($variation['display_regular_price'] * 2.5, 2);
                                    ?>
                                    
                                    <option value="<?php _e($vars); ?>"><?php _e($vars);?> - $<?php _e($prices);?></option>
                                    <?php
                                endforeach; 
                                ?>
	                            </select>
                            </td>
                        <?php else: ?>
                            <td colspan="2" class="product-information__msrp">
                                <b><?php 
	                                echo (is_user_logged_in()) ? "Wholesale: $" : "MSRP: $";
	                                
	                                $price = (is_user_logged_in()) ? number_format(doubleval($product->get_price()), 2) : number_format(doubleval($product->get_price()) * 2.5, 2); 
	                                 echo $price; 
	                                ?> 
                            </td>
                        <?php endif; ?>
                    </tr>
                    <tr>
                        <td class="product-information__sku">
                            <b>SKU: </b> <?php echo $product->get_sku(); ?> 
                        </td>
                        <td class="product-information__category">
                            <b>Category: </b> <?php echo wc_get_product_category_list($product->get_id(), ','); ?>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12" id="product-tabs">
                <ul class="tab">
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Description')" id="defaultOpen"><?php _e("Description", LR_TEXTDOMAIN); ?></a></li>
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Reviews')" ><?php _e("Reviews " . $product->get_review_count(), LR_TEXTDOMAIN); ?></a></li>
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
                    <?php
	                     _e($product->short_description); ?>
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
            <div class="row">
	            <div class="col-md-12" id="cross-sells">
		            <?php woocommerce_cross_sell_display(4, 4);?>
	            </div>
            </div>
        <?php endwhile; ?>  
    </div>
</div>