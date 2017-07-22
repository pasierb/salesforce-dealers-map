;(function() {
  $(document).on('googlemaps:loaded', function() {
    $('.sf-dealers-map').each(function(i, el) {
      bootstrapMap(el)
    })
  });

  $(document).on('click', '.sf-map-center', function(e) {
    var $el = $(e.currentTarget);
    var map = $($el.attr('data-map')).data('map');

    map.setCenter({
      lng: parseFloat($el.attr('data-longitude')),
      lat: parseFloat($el.attr('data-latitude'))
    });
    map.setZoom(12);

    e.preventDefault();
    return false;
  })

  function bootstrapMap(element) {
    var infoWindow;
    var map = new google.maps.Map(element, {
      center: new google.maps.LatLng(47.391262, 8.5058069),
      mapTypeId: 'terrain',
      zoom: 4
    });
    $(element).data('map', map);

    currentPosition(function(pos) {
      pos && map.setCenter(pos);
    });

    $.getJSON('/dealers.json', {
      "coordinates": 1
    }).done(function(response) {
      var markers = response.dealers.map(function(dealer, i) {
        var marker = getMarker(dealer, map);

        marker.addListener('click', function(e) {
          infoWindow = showInfoWindow(map, marker, dealer, infoWindow);
        });

        return marker;
      })

      new MarkerClusterer(map, markers, {
        imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'
      });
    });
  }

  function showInfoWindow(map, marker, dealer, activeInfoWindow) {
    var newInfoWindow;

    activeInfoWindow && activeInfoWindow.close();

    newInfoWindow = new google.maps.InfoWindow({
      content: dealer.name
    });
    newInfoWindow.open(map, marker);

    return newInfoWindow;
  }

  function getMarker(dealer, map) {
    return new google.maps.Marker({
      position: {
        lat: dealer.latitude,
        lng: dealer.longitude
      }
    });
  }

  function currentPosition(cb) {
    if (!navigator.geolocation) { cb(null); }

    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      cb(pos);
    });
  }
})();
