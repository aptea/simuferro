'use strict';

angular.module('simuferroApp')
  .controller('MainCtrl', function ($scope, $log, gtfs) {

    $scope.readFile = function () {
      NProgress.start();
      gtfs.read($scope.file, $scope)
        .then(function (result) {
          $scope.data = result;
          $log.info(result);
          NProgress.done();
        });
    };

  });
