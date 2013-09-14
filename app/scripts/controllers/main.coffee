'use strict';

angular.module('simuferroApp')
  .controller 'MainCtrl', ($scope, $log, gtfs) ->

    $scope.data = {}

    $scope.readFile = ->
      NProgress.start()
      gtfs.read($scope.file, $scope)
        .then (result) ->
          $scope.data = result
          delete $scope.file
          NProgress.done()

