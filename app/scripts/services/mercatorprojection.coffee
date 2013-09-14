'use strict'

#https://developers.google.com/maps/documentation/javascript/examples/map-coordinates?hl=fr&csw=1

angular.module('simuferroApp')
  .service 'MercatorProjection', ->
    TILE_SIZE = 256

    bound = (value, opt_min, opt_max) ->
      value = Math.max(value, opt_min) if opt_min?
      value = Math.min(value, opt_max) if opt_max?
      value

    degreesToRadians = (deg) -> deg * (Math.PI / 180)
    radiansToDegrees = (rad) -> rad / (Math.PI / 180)

    pixelOrigin_ = x: TILE_SIZE / 2, y: TILE_SIZE / 2
    pixelsPerLonDegree_ = TILE_SIZE / 360
    pixelsPerLonRadian_ = TILE_SIZE / (2 * Math.PI)

    fromLatLonToPoint = (latLon, opt_point) ->
      point = opt_point || x: 0, y: 0
      origin = pixelOrigin_

      point.x = origin.x + latLon.lon * pixelsPerLonDegree_
      siny = bound(Math.sin(degreesToRadians(latLon.lat)), -0.9999, 0.9999)
      point.y = origin.y + 0.5 * Math.log((1 + siny) / (1 - siny)) * - pixelsPerLonRadian_
      point

    fromPointToLatLon = (point) ->
      origin = pixelOrigin_
      latRadians = (point.y - origin.y) / -pixelsPerLonRadian_

      lat: radiansToDegrees(2 * Math.atan(Math.exp(latRadians)) - Math.PI / 2)
      lon: (point.x - origin.x) / pixelsPerLonDegree_

    fromLatLonToPoint: fromLatLonToPoint
    fromPointToLatLon: fromPointToLatLon
    TILE_SIZE: TILE_SIZE
