;(function() {
  $(document).on('googlemaps:loaded', () => {
    $('.sf-dealers-map').each((i, el) => bootstrapMap(el));
  });

  $(document).on('click', '.sf-map-center', (e) => {
    const $el = $(e.currentTarget);
    const map = $($el.attr('data-map')).data('map');

    map.setCenter({
      lng: parseFloat($el.attr('data-longitude')),
      lat: parseFloat($el.attr('data-latitude'))
    });
    map.setZoom(12);
  })

  function bootstrapMap(element) {
    let infoWindow;
    const map = new google.maps.Map(element, {
      center: new google.maps.LatLng(47.391262, 8.5058069),
      mapTypeId: 'terrain',
      zoom: 4
    });
    $(element).data('map', map);

    currentPosition(function(pos) {
      pos && map.setCenter(pos);
    });

    $.getJSON('/dealers.json', { "coordinates": 1 }).done((response) => {
      const markers = response.dealers.map((dealer, i) => {
        const marker = getMarker(dealer);

        marker.addListener('click', (e) => {
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
    let newInfoWindow;

    activeInfoWindow && activeInfoWindow.close();

    newInfoWindow = new google.maps.InfoWindow({
      content: `<div>
        <address>
          <strong>${dealer.name}</strong><br>
          ${dealer.street}<br>
          ${dealer.city}, ${dealer.state || ""} ${dealer.zip}<br>
          ${dealer.country}<br>
          <abbr title="Phone">P:</abbr> ${dealer.phone}
        </address>
      </div>`
    });
    newInfoWindow.open(map, marker);

    return newInfoWindow;
  }

  function getMarker(dealer) {
    return new google.maps.Marker({
      position: {
        lat: dealer.latitude,
        lng: dealer.longitude
      }
    });
  }

  function currentPosition(cb) {
    if (!navigator.geolocation) {
      return cb(null);
    }

    navigator.geolocation.getCurrentPosition((position) => {
      cb({
        lat: position.coords.latitude,
        lng: position.coords.longitude
      });
    });
  }
})();
