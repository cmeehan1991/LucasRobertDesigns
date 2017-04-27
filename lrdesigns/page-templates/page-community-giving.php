<?php 
	/*
		Template Name: Community Involvement
	*/
	get_header();
?>

<div class="container-fluid">
	<?php if(have_posts()): while(have_posts()):the_post();?>
	<div class="row">
		<div class="col-md-12">
			<h1><?php _e(get_the_title(), LR_TEXTDOMAIN); ?></h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<p><?php _e(get_the_content(), LR_TEXTDOMAIN);?></p>
		</div>
	</div>
	<?php endwhile; endif; ?>
	<div class="row">
		<div class="col-md-3"></div>
	</div>
		
</div>

<?php get_footer();