'use strict';

angular.module('simuferroApp')
  .factory 'gtfs', ($q, fileReader) ->

    class Agency
      constructor: (agency_id, agency_name, agency_url ) ->
        @gency_id = agency_id
        @agency_name = agency_name
        @agency_url = agency_url

    class Routes
      constructor: (route_id, agency_id) ->
        @route_id = route_id
        @agency_id = agency_id

    class Trips
      constructor: (route_id, service_id, trip_id, shape_id) ->
        @route_id = route_id
        @service_id = agency_id
        @trip_id = trip_id
        @shape_id = shape_id

    class FareRules
      constructor: (fare_id, rule_id) ->
        @fare_id = fare_id
        @rule_id = rule_id

    class FareAttributes
      constructor: (fare_id) ->
        @fare_id = fare_id

    class CalendarDates
      constructor: (service_id) ->
        @service_id = service_id

    class Calendar
      constructor: (service_id) ->
        @service_id = service_id

    class Shapes
      constructor: (shape_id) ->
        @shape_id = shape_id

    class Stops
      constructor: (stop_id) ->
        @stop_id = stop_id

    class StopTimes
      constructor: (trip_id, stop_id) ->
        @trip_id = trip_id
        @stop_id = stop_id

    class Transfers
      constructor: (from_stop_id, to_stop_id) ->
        @from_stop_id = from_stop_id
        @to_stop_id = to_stop_id

    class Frequencies
      constructor: (trip_id) ->
      @trip_id = trip_id

    class FeedInfo
      constructor: (feed_publisher_name,.feed_publisher_url, feed_lang) ->
        @feed_publisher_name = feed_publisher_name
        @feed_publisher_url = feed_publisher_url
        @feed_info = feed_info

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
