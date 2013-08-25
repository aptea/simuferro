'use strict';

angular.module('simuferroApp')
  .controller('MainCtrl', function ($scope, gtfs) {

    $scope.readFile = function () {
      gtfs.read($scope.file, $scope)
        .then(function (result) {
          console.log(result);
        });
    };

  });
