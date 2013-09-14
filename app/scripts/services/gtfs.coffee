'use strict';

angular.module('simuferroApp')
  .factory 'gtfs', ($q, fileReader) ->

    readFile_ = (zip, filename) ->
      zipEntry = zip.files[filename]
      CSV.parse zipEntry.asText() if zipEntry?

    processZip_ = (file) ->
      zip = new JSZip file

      agency: readFile_ zip, 'agency.txt'
      stops: readFile_ zip, 'stops.txt'
      routes: readFile_ zip, 'routes.txt'
      trips: readFile_ zip, 'trips.txt'
      stop_times: readFile_ zip, 'stop_times.txt'
      calendar: readFile_ zip, 'calendar.txt'
      calendar_dates: readFile_ zip, 'calendar_dates.txt'
      fare_attributes: readFile_ zip, 'fare_attributes.txt'
      fare_rules: readFile_ zip, 'fare_rules.txt'
      shapes: readFile_ zip, 'shapes.txt'
      frequencies: readFile_ zip, 'frequencies.txt'
      transfers: readFile_ zip, 'transfers.txt'
      feed_info: readFile_ zip, 'feed_info.txt'

    readGtfs = (file, scope) ->
      deferred = $q.defer()
      type = file.type

      if type != 'application/zip' && type != 'application/x-zip-compressed'
        deferred.reject 'zip file required.'
      else
        fileReader.readAsArrayBuffer(file, scope)
          .then (result) ->
            deferred.resolve(processZip_(result))

      deferred.promise;

    read: readGtfs
