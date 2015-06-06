// Generated by CoffeeScript 1.8.0
(function() {
  (function($) {
    var backToTopEle, backToTopFun, bottomElement, parentElement, stickyElement, unifyHeights, vSearch, vWindow;
    vWindow = $(window);
    vSearch = $('#search-form');
    backToTopEle = $('.backToTop');
    backToTopFun = function() {
      var st, winh;
      st = $(document).scrollTop();
      winh = vWindow.height();
      if (st > 200) {
        backToTopEle.show();
      } else {
        backToTopEle.hide();
      }
      if (!window.XMLHttpRequest) {
        return backToTopEle.css("top", st + winh - 166);
      }
    };
    backToTopEle.click(function() {
      return $('html, body').animate({
        scrollTop: 0
      }, 120);
    });
    backToTopEle.hide();
    vWindow.bind("scroll", backToTopFun);
    stickyElement = $('.stickyel');
    bottomElement = $('footer');
    parentElement = stickyElement.parent();
    if (stickyElement.length > 0) {
      stickyElement.each(function() {
        var fromBottom, fromTop, stopOn;
        fromTop = $(this).offset().top;
        fromBottom = $(document).height() - ($(this).offset().top + $(this).outerHeight());
        stopOn = $(document).height() - bottomElement.offset().top + ($(this).outerHeight() - $(this).height());
        if ((fromBottom - stopOn) > 200) {
          $(this).css('width', parentElement.width()).css('top', 0).css('position', '');
          return $(this).affix({
            offset: {
              top: fromTop,
              bottom: stopOn
            }
          }).on('affix.bs.affix', function() {
            return $(this).css('top', 0).css('position', '');
          });
        }
      });
      vWindow.trigger('scroll');
    }
    unifyHeights = function() {
      return $('.post-row').each(function() {
        var as, childs, maxHeight;
        maxHeight = 0;
        as = $(this).children('a');
        as.each(function() {
          return $(this).children('.post-i').each(function() {
            var height;
            height = $(this).outerHeight();
            if (height > maxHeight) {
              return maxHeight = height;
            }
          });
        });
        childs = $(this).children('.post-i');
        childs.each(function() {
          var height;
          height = $(this).outerHeight();
          if (height > maxHeight) {
            return maxHeight = height;
          }
        });
        childs.css('height', maxHeight);
        return as.each(function() {
          return $(this).children('.post-i').css('height', maxHeight);
        });
      });
    };
    return unifyHeights();
  })(jQuery);

}).call(this);

//# sourceMappingURL=custom.js.map
