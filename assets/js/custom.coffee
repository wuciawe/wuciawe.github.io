(($) ->
  vWindow = $(window)

  vSearch = $('#search-form')

  backToTopEle = $('.backToTop')

  backToTopFun = ->
    st = $(document).scrollTop()
    winh = vWindow.height()
    if st > 200
      backToTopEle.show()
    else
      backToTopEle.hide()
    if !window.XMLHttpRequest
      backToTopEle.css "top", st + winh - 166

  backToTopEle.click ->
    $('html, body').animate
      scrollTop: 0
      120

  backToTopEle.hide()

  vWindow.bind "scroll", backToTopFun

#  vSearch.submit ->
#    query = document.getElementById "google-search"
#    queryString = "http://google.com/search?q=#{query.value}%20site:wuciawe.github.io"
#    window.open queryString

  stickyElement = $('.stickyel')
  bottomElement = $('.stickyfoot')
  parentElement = stickyElement.parent()

  if stickyElement.length > 0
    stickyElement.each ->
      fromTop = $(this).offset().top
      fromBottom = $(document).height() - ($(this).offset().top + $(this).outerHeight())
      stopOn = $(document).height() - bottomElement.offset().top + ($(this).outerHeight() - $(this).height())
      if (fromBottom - stopOn) > 200
        $(this)
          .css 'width', parentElement.width()
          .css 'top', 0
          .css 'position', ''
        $(this)
          .affix
            offset:
              top: fromTop,
              bottom: stopOn
         .on 'affix.bs.affix', () ->
           $(this)
             .css 'top', 0
             .css 'position', ''
    vWindow
      .trigger 'scroll'
) jQuery