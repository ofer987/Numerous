# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize = ->
  mapCanvases = $('#locations').find('.map-canvas')
  for mapCanvas in mapCanvases
    # Location coordinates
    locationLatlng = new google.maps.LatLng $(mapCanvas).attr('latitude'), $(mapCanvas).attr('longitude')

    mapOptions =
      center: locationLatlng
      zoom: 18
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map mapCanvas, mapOptions

    # Marker
    marker = new google.maps.Marker
      position: locationLatlng
      map: map
      title: 'Hello'

$ ->
  google.maps.event.addDomListener window, 'load', initialize
