class InterpolateProvider
  constructor: ($interpolateProvider) ->
    $interpolateProvider.startSymbol '<['
    $interpolateProvider.endSymbol ']>'

class BoardController
  constructor: ($scope, $http, $timeout, DataService) ->
    #    $http.get('/files/about/about.json').success (data)->
#      $scope.skills = data.skills
    oldWindowWidth = DataService.isWindowMiddle(DataService.getWindowWidth())
    $(window).resize ->
      newWindowWidth = DataService.isWindowMiddle(DataService.getWindowWidth())
      if newWindowWidth != oldWindowWidth
        $scope.$apply ->
          unifyHeights()
      oldWindowWidth = newWindowWidth
    unifyHeights = ->
      isWindowMiddle = DataService.isWindowMiddle(DataService.getWindowWidth())
      if isWindowMiddle
        $('.post-row').each ->
          maxWidth = $(this).innerWidth() / 3 - 10
          as = $(this).children 'a'
          childs = $(this).children '.col-md-4'
          childs.css
            'width': maxWidth
          as.each ->
            $(this).children '.col-md-4'
            .css
                'width': maxWidth
          childs.each ->
            $(this).children '.card'
            .css
                'width': maxWidth
          as.each ->
            $(this).children '.col-md-4'
            .each ->
              $(this).children '.card'
              .css
                  'width': maxWidth
        $timeout ->
          $('.post-row').each ->
            maxHeight = 0
            as = $(this).children 'a'
            as.each ->
              $(this).children '.col-md-4'
              .each ->
                $(this).children '.front'
                .each ->
                  height = $(this).innerHeight()
                  maxHeight = height if height > maxHeight
            childs = $(this).children '.col-md-4'
            childs.each ->
              $(this).children '.front'
              .each ->
                height = $(this).innerHeight()
                maxHeight = height if height > maxHeight
            childs.css
              'height': maxHeight
            as.each ->
              $(this).children '.col-md-4'
              .css
                  'height': maxHeight
            childs.each ->
              $(this).children '.card'
              .css
                  'height': maxHeight
              $(this).children '.front'
              .css 'transform', "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
              $(this).children '.back'
              .css 'transform', "translateY(#{maxHeight / 2}px) rotateX(-90deg)"
            as.each ->
              $(this).children '.col-md-4'
              .each ->
                $(this).children '.card'
                .css
                    'height': maxHeight
                $(this).children '.front'
                .css 'transform', "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
                $(this).children '.back'
                .css 'transform', "translateY(#{maxHeight / 2}px) rotateX(-90deg)"
        , 150
      else
        $('.post-row').each ->
          as = $(this).children 'a'
          childs = $(this).children '.col-md-4'
          childs.css
            'height': ''
            'width': ''
          as.each ->
            $(this).children '.col-md-4'
            .css
                'height': ''
                'width': ''
          childs.each ->
            $(this).children '.card'
            .css
                'height': ''
                'width': ''
            $(this).children '.front'
            .css 'transform', ''
            $(this).children '.back'
            .css 'transform', ''
          as.each ->
            $(this).children '.col-md-4'
            .each ->
              $(this).children '.card'
              .css
                  'height': ''
                  'width': ''
              $(this).children '.front'
              .css 'transform', ''
              $(this).children '.back'
              .css 'transform', ''

    unifyHeights()

angular.module('blogApp', [])
.config(['$interpolateProvider', InterpolateProvider])
.factory 'DataService', ['$window', ($window) ->
  getWindowWidth: ->
    $window.innerWidth
  isWindowMiddle: (width) ->
    width >= 992
]
.directive 'hoverClass', ['DataService', (DataService) ->
    restrict: 'A'
    scope:
      hoverClass: '@'
    link: (scope, element) ->
      element.on 'mouseenter', ->
        if DataService.isWindowMiddle(DataService.getWindowWidth())
          maxHeight = element.children()[0].offsetHeight
          angular.element(element.children()[0]).css
            'transform': "translateY(-#{maxHeight / 2}px) rotateX(90deg)"
          angular.element(element.children()[1]).css
            'transform': "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
          element.addClass scope.hoverClass
      element.on 'mouseleave', ->
        if DataService.isWindowMiddle(DataService.getWindowWidth())
          maxHeight = element.children()[0].offsetHeight
          angular.element(element.children()[0]).css
            'transform': "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
          angular.element(element.children()[1]).css
            'transform': "translateY(#{maxHeight / 2}px) rotateX(-90deg)"
          element.removeClass scope.hoverClass
]
.controller 'boardController', ['$scope', '$http', '$timeout', 'DataService', BoardController]
.controller 'footerController', ['$scope', 'DataService', ($scope, DataService) ->
#  alert 'start'
#  $.each document.styleSheets, (i,sheet) ->
#    if sheet.href == 'https://fonts.googleapis.com/css?family=Lato:400,400italic|Dawning+of+a+New+Day|Cutive+Mono|Source+Code+Pro'
#      if !((sheet.rules && sheet.rules.length != 0) || (sheet.cssRules && sheet.cssRules.length != 0))
#        if !document.getElementById('backupfontcss')
#        sheet.href = "http://fonts.useso.com/css?family=Lato:400,400italic|Dawning+of+a+New+Day|Cutive+Mono|Source+Code+Pro"
#        alert 'changed'
#          $('<link id="backupfontcss" rel="stylesheet" type="text/css" href="http://fonts.useso.com/css?family=Lato:400,400italic|Dawning+of+a+New+Day|Cutive+Mono|Source+Code+Pro" />').appendTo('head')

  $scope.isMiddle = ->
    DataService.isWindowMiddle(DataService.getWindowWidth())
]