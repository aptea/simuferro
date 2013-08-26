'use strict';

angular.module('simuferroApp')
  .controller('MainCtrl', function ($scope, $log, gtfs) {

    $scope.france = {
      lat: 46.5,
      lng: 2.5,
      zoom: 6
    };

    $scope.layers = {
      baselayers: {
        empty: { type: 'xyz', url: '', name: 'Empty layer', layerOptions: {}}

      }
    };
    $scope.markers = {};

    $scope.readFile = function () {
      NProgress.start();
      gtfs.read($scope.file, $scope)
        .then(function (result) {
          $scope.data = result;

          // process stops
          var ret = {};
          angular.forEach($scope.data.stops, function (stop, index) {
            ret["m" + index] = {
              icon: L.icon({ iconUrl: 'images/railway-station-16.png', iconSize: new L.Point(8, 8)}),
              lat: parseFloat(stop.stop_lat.substring(0,6)),
              lon: parseFloat(stop.stop_lon.substring(0,6)),
              message: stop.stop_name
            };
          });
          $scope.markers = ret;

          $scope.file = undefined;

          $log.info(result);
          NProgress.done();
        });
    };

  });
