;(function() {
  $(document).on("turbolinks:load", init);

  function init() {
    if (window.google && window.google.maps) {
      $(document).trigger('googlemaps:loaded');
    }
  }
})();
