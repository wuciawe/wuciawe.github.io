class InterpolateProvider
  constructor: ($interpolateProvider) ->
    $interpolateProvider.startSymbol '<['
    $interpolateProvider.endSymbol ']>'

class BoardController
  constructor: ($scope, $http, DataService) ->
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
      $('.post-row').each ->
        maxHeight = 0
        maxWidth = $(this).innerWidth() / 3 - 10
        as = $(this).children 'a'
        if isWindowMiddle
          as.each ->
            $(this).children '.col-md-4'
            .each ->
              $(this).children '.front'
              .each ->
                height = $(this).innerHeight()
                maxHeight = height if height > maxHeight
        childs = $(this).children '.col-md-4'
        if isWindowMiddle
          childs.each ->
            $(this).children '.front'
            .each ->
              height = $(this).innerHeight()
              maxHeight = height if height > maxHeight
          childs.css
            'height': maxHeight
            'width': maxWidth
          as.each ->
            $(this).children '.col-md-4'
            .css
                'height': maxHeight
                'width': maxWidth
          childs.each ->
            $(this).children '.card'
            .css
                'height': maxHeight
                'width': maxWidth
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
                  'width': maxWidth
              $(this).children '.front'
              .css 'transform', "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
              $(this).children '.back'
              .css 'transform', "translateY(#{maxHeight / 2}px) rotateX(-90deg)"
        else
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
.controller 'boardController', ['$scope', '$http', 'DataService', BoardController]
.controller 'footerController', ['$scope', 'DataService', ($scope, DataService) ->
  $scope.isMiddle = ->
    DataService.isWindowMiddle(DataService.getWindowWidth())
]