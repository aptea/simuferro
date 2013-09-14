'use strict';

angular.module('simuferroApp')
  .directive 'fileInput', ($parse) ->
    restrict: 'A'
    template: '<input type="file"></input>'
    replace: true
    link: (scope, element, attributes) ->
      get = $parse attributes.fileInput
      set = get.assign
      change = $parse attributes.onChange

      element.bind 'change', ->
        scope.$apply ->
          set scope, element[0].files[0]
          change scope
          return
      return
