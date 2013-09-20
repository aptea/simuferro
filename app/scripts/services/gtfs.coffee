 'use strict';

angular.module('simuferroApp')
  .factory 'gtfs', ($q, fileReader) ->

    class Agency
      constructor: (agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone, agency_fare_url ) ->
        @gency_id = agency_id
        @agency_name = agency_name
        @agency_url = agency_url
        @agency_timezone = agency_timezone
        @agency_lang = agency_lang
        @agency_phone = agency_phone
        @agency_fare_url = agency_fare_url

    class Routes
      constructor: (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color) ->
        @route_id = route_id
        @agency_id = agency_id
        @route_short_name = route_short_name
        @route_long_name =  route_long_name
        @route_desc = route_desc
        @route_type = route_type
        @route_url = route_url
        @route_color = route_color
        @route_text_color = route_text_color

    class Trips
      constructor: (route_id, service_id, trip_id, shape_id, trip_headsign, trip_short_name, direction_id, block_id, shape_id, wheelchair_accessible) ->
        @route_id = route_id
        @service_id = agency_id
        @trip_id = trip_id
        @shape_id = shape_id
        @trip_headsign = trip_headsign
        @trip_short_name = trip_short_name
        @direction_id = direction_id
        @block_id = block_id
        @shape_id = shape_id
        @wheelchair_accessible = wheelchair_accessible

    class FareRules
      constructor: (fare_id, rule_id, origin_id, destination_id, contains_id) ->
        @fare_id = fare_id
        @rule_id = rule_id
        @origin_id = origin_id
        @destination_id = destination_id
        @contains_id = contains_id

    class FareAttributes
      constructor: (fare_id, price, currency_type, payment_method, transfers, transfer_duration) ->
        @fare_id = fare_id
        @currency_type = currency_type
        @payment_method = payment_method
        @transfers = transfers
        @transfer_duration = transfer_duration

    class CalendarDates
      constructor: (service_id, date, exception_type) ->
        @service_id = service_id
        @date = date
        @exception_type = exception_type

    class Calendar
      constructor: (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date) ->
        @service_id = service_id
        @monday = monday
        @tuesday = tuesday
        @wednesday = wednesday
        @thursday = thursday
        @friday = friday
        @saturday = saturday
        @sunday = sunday
        @start_date = start_date
        @end_date = end_date

    class Shapes
      constructor: (shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, shape_dist_traveled) ->
        @shape_id = shape_id
        @shape_pt_lat = shape_pt_lat
        @shape_pt_lon = shape_pt_lon
        @shape_pt_sequence = shape_pt_sequence
        @shape_dist_traveled = shape_dist_traveled

    class Stops
      constructor: (stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, stop_timezone, wheelchair_boarding) ->
        @stop_id = stop_id
        @stop_code = stop_code
        @stop_name = stop_name
        @stop_desc = stop_desc
        @stop_lat = stop_lat
        @stop_lon = stop_lon
        @zone_id = zone_id
        @stop_url = stop_url
        @location_type = location_type
        @parent_station = parent_station
        @stop_timezone = stop_timezone
        @wheelchair_boarding = wheelchair_boarding

    class StopTimes
      constructor: (trip_id, stop_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled  ) ->
        @trip_id = trip_id
        @stop_id = stop_id
        @arrival_time = arrival_time
        @departure_time = departure_time
        @stop_id = stop_id
        @stop_sequence = stop_sequence
        @stop_headsign = stop_headsign
        @pickup_type = pickup_type
        @drop_off_type = drop_off_type
        @shape_dist_traveled = shape_dist_traveled

    class Transfers
      constructor: (from_stop_id, to_stop_id, transfer_type, min_transfer_time) ->
        @from_stop_id = from_stop_id
        @to_stop_id = to_stop_id
        @transfer_type = transfer_type
        @min_transfer_time = min_transfer_time

    class Frequencies
      constructor: (trip_id, start_time, end_time, headway_secs, exact_times) ->
        @trip_id = trip_id
        @start_time = start_time
        @end_time = end_time
        @headway_secs = headway_secs
        @exact_times = exact_times

    class FeedInfo
      constructor: (feed_publisher_name,.feed_publisher_url, feed_lang, feed_start_date, feed_end_date, feed_version) ->
        @feed_publisher_name = feed_publisher_name
        @feed_publisher_url = feed_publisher_url
        @feed_info = feed_info
        @feed_lang = feed_lang
        @feed_start_date = feed_start_date
        @feed_end_date = feed_end_date
        @feed_version = feed_version

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
