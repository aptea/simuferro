'use strict';

angular.module('simuferroApp')
  .factory 'fileReader', ($q) ->

    onLoad_ = (reader, deferred, scope) -> () -> scope.$apply -> deferred.resolve reader.result

    onError_ = (reader, deferred, scope) -> () -> scope.$apply -> deferred.reject reader.result

    onProgress_ = (reader, scope) -> (event) -> scope.$broadcast 'fileProgress',
      total: event.total
      loaded: event.loaded

    getReader_ = (deferred, scope) ->
      reader = new FileReader()
      if scope
        reader.onload = onLoad_ reader, deferred, scope
        reader.onerror = onError_ reader, deferred, scope
        reader.onprogress = onProgress_ reader, scope
      reader

    readAsDataURL = (file, scope) ->
      deferred = $q.defer()
      reader = getReader_ deferred, scope
      reader.readAsDataURL file
      deferred.promise

    readAsArrayBuffer = (file, scope) ->
      deferred = $q.defer()
      reader = getReader_ deferred, scope
      reader.readAsArrayBuffer file
      deferred.promise

    readAsBinaryString = (file, scope) ->
      deferred = $q.defer()
      reader = getReader_ deferred, scope
      reader.readAsBinaryString file
      deferred.promise

    readAsText = (file, scope, encoding) ->
      deferred = $q.defer()
      reader = getReader_ deferred, scope
      reader.readAsText file, encoding
      deferred.promise

    readAsDataUrl: readAsDataURL
    readAsArrayBuffer: readAsArrayBuffer
    readAsText: readAsText
    readAsBinaryString: readAsBinaryString
