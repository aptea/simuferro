'use stict'

angular.module('simuferroApp')
  .factory 'animate', ($window, $rootScope) ->
    requestAnimationFrame = $window.requestAnimationFrame || $window.mozRequestAnimationFrame || $window.msRequestAnimationFrame || $window.webkitRequestAnimationFrame

    (tick) -> requestAnimationFrame () -> $rootScope.$apply tick