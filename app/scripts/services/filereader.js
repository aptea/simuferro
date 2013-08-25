'use strict';

angular.module('simuferroApp')
  .factory('fileReader', function ($q) {
    var onLoad_ = function(reader, deferred, scope) {
      return function () {
        scope.$apply(function () {
          deferred.resolve(reader.result);
        });
      };
      };

    var onError_ = function (reader, deferred, scope) {
      return function () {
        scope.$apply(function () {
          deferred.reject(reader.result);
        });
      };
    };

    var onProgress_ = function(reader, scope) {
      return function (event) {
        scope.$broadcast("fileProgress", {
          total: event.total,
          loaded: event.loaded
        });
      };
    };

    var getReader_ = function(deferred, scope) {
      var reader = new FileReader();
      if (scope) {
        reader.onload = onLoad_(reader, deferred, scope);
        reader.onerror = onError_(reader, deferred, scope);
        reader.onprogress = onProgress_(reader, scope);
      }
      return reader;
    };

    var readAsDataURL = function (file, scope) {
      var deferred = $q.defer();
      var reader = getReader_(deferred, scope);
      reader.readAsDataURL(file);
      return deferred.promise;
    };

    var readAsArrayBuffer = function (file, scope) {
      var deferred = $q.defer();
      var reader = getReader_(deferred, scope);
      reader.readAsArrayBuffer(file);
      return deferred.promise;
    };

    var readAsText = function (file, scope, opt_encoding) {
      var deferred = $q.defer();
      var reader = getReader_(deferred, scope);
      reader.readAsText(file, opt_encoding);
      return deferred.promise;
    };

    var readAsBinaryString = function (file, scope, opt_encoding) {
      var deferred = $q.defer();
      var reader = getReader_(deferred, scope);
      reader.readAsBinaryString(file);
      return deferred.promise;
    };

    return {
      readAsDataUrl: readAsDataURL,
      readAsArrayBuffer: readAsArrayBuffer,
      readAsText: readAsText,
      readAsBinaryString: readAsBinaryString
    };
  });