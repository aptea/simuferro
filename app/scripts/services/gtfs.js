'use strict';

angular.module('simuferroApp')
  .factory('gtfs', function ($q, fileReader) {

    var readAgency_ = function (csv) {

    }

    var readFile_ = function (zip, filename) {
      var zipEntry = zip.files[filename];
      if (zipEntry) {
        return CSV.parse(zipEntry.asText());
      }
    }

    var processZip_ = function (file) {
      var zip = new JSZip(file);
      return {
        agency: readFile_(zip, 'agency.txt'),
        stops: readFile_(zip, 'stops.txt'),
        routes: readFile_(zip, 'routes.txt'),
        trips: readFile_(zip, 'trips.txt'),
        stop_times: readFile_(zip, 'stop_times.txt'),
        calendar: readFile_(zip, 'calendar.txt'),
        calendar_dates: readFile_(zip, 'calendar_dates.txt'),
        fare_attributes: readFile_(zip, 'fare_attributes.txt'),
        fare_rules: readFile_(zip, 'fare_rules.txt'),
        shapes: readFile_(zip, 'shapes.txt'),
        frequencies: readFile_(zip, 'frequencies.txt'),
        transfers: readFile_(zip, 'transfers.txt'),
        feed_info: readFile_(zip, 'feed_info.txt')
      };
    }

    var readGtfs = function (file, scope) {
      var deferred = $q.defer();

      // todo : handle errors
      if (file.type !== 'application/zip' && file.type !== 'application/x-zip-compressed') {
        deferred.reject('zip file required.');
      }
      else {
        fileReader.readAsArrayBuffer(file, scope)
          .then(function (result) { deferred.resolve(processZip_(result)); });
      }

      return deferred.promise;
    };

    return {
      read: readGtfs
    }
  });