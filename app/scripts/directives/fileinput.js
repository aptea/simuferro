'use strict';

angular.module('simuferroApp')
  .directive('fileInput', function ($parse) {
    return {
      restrict: 'A',
      template: '<input type="file"></input>',
      replace: true,
      link: function (scope, element, attributes) {
        var get = $parse(attributes.fileInput);
        var set = get.assign;
        var change = $parse(attributes.onChange);

        element.bind('change', function () {
          scope.$apply(function () {
            set(scope, element[0].files[0]);
            change(scope);
          });
        });
      }
    }
  });