function custom() {

  document.title = user_info["name"].concat(" | Photos Map");

  addFavicon();
  addFooter();

  var div_sw_photos = document.createElement("DIV");
  div_sw_photos.setAttribute("class", "unselected-photos");
  div_sw_photos.addEventListener('click', function () { openPhotos() })
  div_sw_photos.innerText = "PHOTOS";

  var div_sw_exhibits = document.createElement("DIV");
  div_sw_exhibits.setAttribute("class", "selected-exhibits");
  div_sw_exhibits.innerText = "EXHIBITS";

  var div_map_switcher = document.createElement("DIV");
  div_map_switcher.setAttribute("class", "map-switcher");
  div_map_switcher.appendChild(div_sw_photos);
  div_map_switcher.appendChild(div_sw_exhibits);
  document.body.appendChild(div_map_switcher);

  var div_panel = document.createElement("DIV");
  div_panel.setAttribute("id", "panel");
  div_panel.setAttribute("class", "countries-panel");

  countries.sort(function(a,b) {
    var delta = (a[3]-b[3]);
    if (delta == 0) {
      return (a[2]-b[2]);
    }
    return delta;
   });

  for (var i = countries.length-1; i >= 0; i--) {
    var country_code = countries[i][0];
      addIcon(country_code, div_panel);
  }

  //addIcon('EU', div_panel);
  //addIcon('WW', div_panel);

  document.body.appendChild(div_panel);

  countries.forEach(addListener);

  //document.getElementById('EU').addEventListener('click', function() { fitRegion('EU') });
  //document.getElementById('WW').addEventListener('click', function() { fitRegion('WW') });


  // Functions

  function addFavicon() {
    var favicon = document.createElement("LINK");
    favicon.setAttribute("rel", "shortcut icon");
    favicon.setAttribute("type", "image/x-icon");
    favicon.setAttribute("href", "../../icons/favicon.ico");
    document.head.append(favicon);
  }

  function addIcon(country_code, panel) {
    var country_name = countries_bbox[country_code][0];
    var elem = document.createElement("IMG");
    elem.setAttribute("id", country_code);
    elem.setAttribute("class", "icon");
    elem.setAttribute("src", getIconSrc(country_name));
    elem.setAttribute("title", country_name);
    elem.setAttribute("alt", country_name);
    var div_icon = document.createElement("DIV");
    div_icon.setAttribute("class", "flag-icon");
    div_icon.appendChild(elem);
    panel.appendChild(div_icon);
  }

  function getIconSrc(name) {
    return "../icons/".concat(name.replace(" ", "-").toLowerCase()).concat(".svg");
  }

  function addListener(country) {
    var country_code = country[0];
    document.getElementById(country_code).addEventListener('click', function() { fitRegion(country_code) });
  }

  function fitRegion(region) {

    var bboxes = countries_bbox[region][1]

    var west = bboxes[0];
    var south = bboxes[1];
    var east = bboxes[2];
    var north = bboxes[3];

    map.fitBounds([
        [west, south],
        [east, north]],
        {padding: 50}
    );

  };

  function openPhotos() {
      window.location.replace("https://hpfilho.github.io/map/");
  }

  function addFooter() {
    var footer = document.createElement("DIV");
    footer.setAttribute("class", "footer");
    footer.innerHTML = "Icons made by <a href=\"https://www.flaticon.com/authors/turkkub\" title=\"turkkub\" target=\"_blank\">turkkub</a> (World) and <a href=\"https://www.flaticon.com/authors/freepik\" title=\"Freepik\">Freepik</a> (Countries) from <a href=\"https://www.flaticon.com/\" title=\"Flaticon\" target=\"_blank\">www.flaticon.com</a>";
    document.body.append(footer);
  }

}
