---
---

#
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

  vSearch.submit ->
    query = document.getElementById "google-search"
    queryString = "http://google.com/search?q=#{query.value}%20site:wuciawe.github.io"
    window.open queryString
) jQuery

