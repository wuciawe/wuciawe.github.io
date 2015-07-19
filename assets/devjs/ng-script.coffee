class InterpolateProvider
  constructor: ($interpolateProvider) ->
    $interpolateProvider.startSymbol '<['
    $interpolateProvider.endSymbol ']>'

class SkillsController
  constructor: ($scope, $http) ->
    $http.get('/files/about/about.json').success (data)->
      $scope.skills = data.skills

angular.module('skillsApp', [])
.config(['$interpolateProvider', InterpolateProvider])
.directive 'hoverClass', ->
    restrict: 'A'
    scope:
      hoverClass: '@'
    link: (scope, element) ->
      element.on 'mouseenter', ->
        maxHeight = element.children()[0].offsetHeight
        angular.element(element.children()[0]).css
          'transform': "translateY(-#{maxHeight / 2}px) rotateX(90deg)"
        angular.element(element.children()[1]).css
          'transform': "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
        element.addClass scope.hoverClass
      element.on 'mouseleave', ->
        maxHeight = element.children()[0].offsetHeight
        angular.element(element.children()[0]).css
          'transform': "translateZ(#{maxHeight / 2}px) rotateX(0deg)"
        angular.element(element.children()[1]).css
          'transform': "translateY(#{maxHeight / 2}px) rotateX(-90deg)"
        element.removeClass scope.hoverClass

.controller 'skillsController', ['$scope', '$http', SkillsController]