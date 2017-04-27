<?php 
	/*
		Template Name: Vendor Page
	*/
	get_header();
?>

<div class="container-fluid">
	<!-- Need to add some kind of hero banner here --> 
	<div class="row">
		<article class="col-sm-12 col-md-4 col-md-offset-4">
			<?php if(have_posts()): while(have_posts()): the_post(); ?>
				<?php the_content(); ?>
				
				<?php 
				$list_type = get_field('list_type');
				$csv = get_field('api');
				$api = get_field('csv');
				$xlsx = get_field('xls/x');	
				if($csv){
					$list = $csv;
				}else if($api){
					$list = $api['url'];
				}else if($xlsx){
					$list = $xlsx['url'];
				}
				?>
				<!-- List data -->
				<input type = "hidden" class="endpoint" data-endpoint="<?php echo $list; ?>" data-type="<?php echo $list_type; ?>"/>
				<div id="vendor-list-wrap">
					<div class="search-wrap">
						<input class="search" id="vendor-search" placeholder="Search..." type="search"/> <input class="submit" type="submit" value="Submit Search"/>
					</div>
					<ul class="list" id="donor-list"></ul>
					<ul class="pagination"></ul>
				</div>
			<?php endwhile; else: ?>
				<p>There are no results matching your search.</p>
			<?php endif; ?>
		</article>
	</div>	
</div>
<?php get_footer();
