<?php 
	/*
		Template Name: Newsletter Page
	*/
	get_header();
?>
<div class="container-fluid">
	<?php if(have_posts()):while(have_posts()):the_post();?>
		<div class="row">
			<div class="col-md-12" align="center">
				<h1 class="page-header__newsletter"><?php the_title();?></h1>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12 col-md-6 col-md-offset-4">
				<?php the_content();?>
			</div>
		</div>
	<?php endwhile; else: ?>
		<div class="row">
			<div class="col-md-12">
				<p>We are sorry, but it appears there is nothing here.</p>
			</div>
		</div>
	<?php endif; ?>
</div>

<?php get_footer();