class InterpolateProvider
  constructor: ($interpolateProvider) ->
    $interpolateProvider.startSymbol '<['
    $interpolateProvider.endSymbol ']>'

class SkillsController
  constructor: ($scope, $http) ->
    $http.get('/files/about/about.json').success (data)->
      $scope.skills = data.skills

angular.module('skillsApp', []).config(['$interpolateProvider', InterpolateProvider]).controller 'skillsController', ['$scope', '$http', SkillsController]