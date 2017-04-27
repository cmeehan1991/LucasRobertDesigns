<?php
/*
 * @package: Lucas Robert Designst
 * @subpackage: lrdesigns
 */
get_header();
?>
<div class="container-fluid">
    <div class='row'>
        <div class="col-md-12">
            <?php _e(the_title('<h1 class="page-header" align="center">', '</h1>'), LR_TEXTDOMAIN); ?>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 col-md-4 col-md-offset-5">
            <div class="contact-message"></div>
            <form class="contact-form" method="post" onsubmit="return sendEmail()">
                <div class='row'>
                    <div class='col-xs-12 col-md-6'>
                        <label for='name'>Name:</label><br/>
                        <input type='text' name='name' size="50" required/>
                    </div>
                </div>
                <div class='row'>
                    <div class="col-xs-12 col-md-6">
                        <label for='email'>Email:</label><br/>
                        <input type='email' name='email' size="50" required/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-12 col-md-6">
                        <label for="phone">Phone:</label><br/>
                        <input type='tel' name='tel' size="50" required/>
                    </div>
                </div>
                <div class='row'>
                    <div class="col-xs-12 col-md-6">
                        <label for='company'>Company:</label></br>
                        <input type='text' name='company' size="50"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-12 col-md-6">
                        <label for="message">Message:</label>
                        <textarea rows="6" cols="50" name="message" required></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-12 col-md-6 col-md-offset-1">
                        <button type="submit" class="submit-button" style="width:100%">Send Message</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 col-md-6 col-md-offset-3">
            <div class="row">
                <div class="col-xs-12 col-md-offset-4 col-md-3">
                    <address>
                        <b>Lucas Robert Designs&trade;</b><br/>
                        Burlington, NC 27215
                    </address>
                </div>
                <div class="col-xs-12 col-md-3">
                    <address>
                        <b>Tel: </b><a href="tel:336.584.1435"/>(336) 213-2122</a><br/>
                        <b>Email: </b><a href="mailto:lucasrovert2004@aol.com"/>lucasrobert2004@aol.com</a>
                    </address>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
get_footer();
