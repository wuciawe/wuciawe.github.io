/**
 * Created by jwhu on 14-8-13.
 */

jQuery.noConflict();
jQuery(document).ready(function(){

    var backToTopEle = jQuery('<div class="backToTop col-sm-offset-10 pull-right"><img src="/assets/image/backtotop.png"></div>').appendTo(jQuery("body")).click(function() {
        jQuery("html, body").animate({ scrollTop: 0 }, 120);
    }), backToTopFun = function() {
        var st = jQuery(document).scrollTop(), winh = jQuery(window).height();
        (st > 200)? backToTopEle.show(): backToTopEle.hide();
        //IE6下的定位
        if (!window.XMLHttpRequest) {
            backToTopEle.css("top", st + winh - 166);
        }
    };

    backToTopEle.hide();
    jQuery(window).bind("scroll", backToTopFun);
    jQuery('div.main a,div.pic a').attr('target', '_blank');

    jQuery(window).resize(function () {
        jQuery('body').css('padding-top', parseInt(jQuery('nav').css("height"))+10);
    });

    jQuery(window).resize();
    jQuery(window).load(function () {
        jQuery('body').css('padding-top', parseInt(jQuery('nav').css("height"))+10);
    });
});

jQuery("#search-form").submit(function(){
    var query = document.getElementById("google-search").value;
    window.open("http://google.com/search?q=" + query+ "%20site:" + "wuciawe.github.io");
});