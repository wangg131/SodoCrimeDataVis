// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function() {
  L.mapbox.accessToken = 'pk.eyJ1IjoidGFrb3l1a2k0NTYiLCJhIjoiY2lvYWtmbzBoMDNtaXZna3E4bTcybWE5aiJ9.yRxeAy1QnclgMHDNZtCPLw';

  var map = L.mapbox.map('map', 'mapbox.streets')
      .setView([47.5951456, -122.331601], 14);

  $.ajax({
    dataType: 'text',
    url: '/',
    success: function(data) {
      var geojson;
      geojson = $.parseJSON(data);
      return map.featureLayer.setGeoJSON(geojson);
    }
  });
});
