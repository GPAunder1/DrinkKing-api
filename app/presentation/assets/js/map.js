function initmap(){
  // Create the script tag, set the appropriate attributes
  var script = document.createElement('script');
  script.src = 'https://maps.googleapis.com/maps/api/js?key=' + MAP_API_TOKEN + '&callback=initMap&v=beta&map_ids=8e25363590309254';
  script.defer = true;
  // Attach your callback function to the `window` object
  window.initMap = function() {
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 24.7961217, lng: 120.9966699 },
      zoom: 15,
      mapId: "8e25363590309254"
    });

    const marker = new google.maps.Marker({
      map,
      position: { lat: 24.7961217, lng: 120.9966699 },
      animation: google.maps.Animation.DROP,
    });
  };

  // Append the 'script' element to 'head'
  document.head.appendChild(script);
}

function create_marker(shop){
    shop = json_formatter(shop);

    const icon = {
      url: "https://www.flaticon.com/svg/static/icons/svg/3106/3106180.svg",
      scaledSize: new google.maps.Size(30, 30),
      origin: new google.maps.Point(0,0), // origin
      // anchor: new google.maps.Point(0, 0) // anchor
    };

    const infowindow = new google.maps.InfoWindow({
      content: shop.name
    });

    const marker = new google.maps.Marker({
      map,
      position: { lat: shop.latitude, lng: shop.longitude},
      icon: icon,
      animation: google.maps.Animation.DROP,
    });

    marker.addListener("mouseover" , () => {
      infowindow.open(map, marker);
    });

    marker.addListener("mouseout" , () => {
      infowindow.close();
    });

    marker.addListener("click", () => {
      make_toast_info(shop);
      $('#toast').toast('show');
    })
}

function json_formatter(string){
  string = string.replace(/&quot;/g, '"');
  string = string.replace(/&gt;/g, '');
  string = string.replace(/\n/g, ' ');
  json_format_string = JSON.parse(string);
  return json_format_string
}

$(document).ready(function(){
  initmap();
});
