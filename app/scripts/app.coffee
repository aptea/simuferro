'use strict';

angular.module('simuferroApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'

      .otherwise
        redirectTo: '/'
