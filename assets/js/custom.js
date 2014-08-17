/**
 * Created by jwhu on 14-8-13.
 */

jQuery.noConflict();
jQuery(document).ready(function(){

    var vWindow = jQuery(window);
    var vBody = jQuery('body');
    var vNav = jQuery('nav');
    var vSearch = jQuery('#search-form');

    var backToTopEle = jQuery('.backToTop');
    backToTopEle.click(function() {
        jQuery("html, body").animate({ scrollTop: 0 }, 120);
    });

    var backToTopFun = function() {
        var st = jQuery(document).scrollTop(), winh = vWindow.height();
        (st > 200)? backToTopEle.show(): backToTopEle.hide();
        //IE6下的定位
        if (!window.XMLHttpRequest) {
            backToTopEle.css("top", st + winh - 166);
        }
    };

    backToTopEle.hide();
    vWindow.bind("scroll", backToTopFun);
    jQuery('div.main a,div.pic a').attr('target', '_blank');

    //vWindow.resize(function () {
    //    vBody.css('padding-top', parseInt(vNav.css("height"))+10);
    //});

    //vWindow.load(function () {
    //    vBody.css('padding-top', parseInt(vNav.css("height"))+10);
    //});

    vSearch.submit(function(){
        var query = document.getElementById("google-search").value;
        window.open("http://google.com/search?q=" + query+ "%20site:" + "wuciawe.github.io");
    });
});

