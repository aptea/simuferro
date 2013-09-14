'use strict'

angular.module('simuferroApp')
  .directive 'drawing', (MercatorProjection, animate) ->
    restrict: 'A'
    scope:
      stops: '='
      zoom: '@'
    link: (scope, element) ->

      scope.origin_point = x: 0, y: 0
      scope.panning = false
      last = x: undefined, y: undefined

      element.bind 'mousewheel', (e) ->
        zoom = scope.zoom * 1
        zoom += if e.originalEvent.wheelDelta > 0 then 1 else -1

        if zoom < 1
          zoom = 1
        else if zoom > 15
          zoom = 15

        scope.$apply () ->
          scope.zoom_center = x: e.offsetX, y: e.offsetY
          scope.zoom = zoom

      element.bind 'mousedown', (e) ->
        if not scope.panning
          last = x: e.offsetX, y: e.offsetY
          scope.$apply () -> scope.panning = true
        e.preventDefault()

      element.bind 'mousemove', (e) ->
        if scope.panning
          current = x: e.offsetX, y: e.offsetY
          scope.$apply ->
            scope.origin_point =
              x: scope.origin_point.x + (current.x - last.x)
              y: scope.origin_point.y + (current.y - last.y)
          last = current

      element.bind 'mouseup', (e) ->
        if scope.panning
          scope.$apply () -> scope.panning = false

      scope.$watch 'zoom', (value, old) ->
        # adjust center
        if value != old
          oldNumTiles = 1 << old
          newNumTiles = 1 << value

          width = element[0].offsetWidth
          height = element[0].offsetHeight

          if (value > old)
            scope.origin_point =
              x: (scope.origin_point.x *  newNumTiles / oldNumTiles) - scope.zoom_center.x
              y: (scope.origin_point.y *  newNumTiles / oldNumTiles) - scope.zoom_center.y
          else
            scope.origin_point =
              x: ((scope.origin_point.x + scope.zoom_center.x) *  newNumTiles / oldNumTiles)
              y: ((scope.origin_point.y+ scope.zoom_center.y) *  newNumTiles / oldNumTiles)

        scope.zoom_center = x: (width/2), y: (height/2)

      adjustCanvas_ = ->
        width = element[0].offsetWidth
        height = element[0].offsetHeight
        ctx = element[0].getContext '2d'
        ctx.canvas.width  = width
        ctx.canvas.height = height
        ctx

      renderGrid_ = (ctx) ->
        width = ctx.canvas.width
        height = ctx.canvas.height

        tile_size = MercatorProjection.TILE_SIZE

        # Draw the grid
        ctx.lineWidth = 0.1
        ctx.strokeStyle = 'lightgray'

        for x in [0..width]
          if parseInt(x - scope.origin_point.x) % tile_size == 0
            ctx.moveTo x, 0
            ctx.lineTo x, height
            ctx.stroke()

        for y in [0..height]
          if parseInt(y - scope.origin_point.y) % tile_size == 0
            ctx.moveTo 0, y
            ctx.lineTo width, y
            ctx.stroke()

      render = ->
        ctx = adjustCanvas_()
        ctx.font = '15px Arial'

        width = ctx.canvas.width
        height = ctx.canvas.height

        # Clean the background
        ctx.clearRect 0, 0, width, height

        # Process zoom level (1 -> 19 - default: 2)
        scope.zoom = 2 if not scope.zoom
        zoom = scope.zoom
        numTiles = 1 << zoom

        # Draw the grid
        renderGrid_ ctx

        # Draw stops
        ctx.strokeStyle = 'black'
        if scope.stops
          for stop in scope.stops
            lon = parseFloat stop.stop_lon.substring 0, 6
            lat = parseFloat stop.stop_lat.substring 0, 6

            # Récupère les coordonnées au niveau mondial du point
            worldCoordinate = MercatorProjection.fromLatLonToPoint(lat: lat, lon: lon)

            pixelCoordinate =
              x: worldCoordinate.x * numTiles
              y: worldCoordinate.y * numTiles

            ctx.beginPath()
            ctx.arc pixelCoordinate.x + scope.origin_point.x, pixelCoordinate.y + scope.origin_point.y, 0.2 * zoom, 0, Math.PI*2, true
            ctx.closePath()
            ctx.fill()
        else
          ctx.fillText 'pas de données', 10, 20

        animate render

      render()



