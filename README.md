# My "Photos & Trips" Website

This is the code repository for my [website](https://haraldoalbergaria.page/).

The purpose of the site is to showcase my activities as a hobbyist photographer. It was written in _**Javascript**_, _**HTML**_ and _**CSS**_, and it has buttons to my other photography sites, social media accounts and a photos map.

[![Haraldo Albergaria Photography](https://github.com/HaraldoFilho/haraldoalbergaria.page/blob/master/img/site.png)](https://haraldoalbergaria.page/)

## The Map

One of the buttons opens a [map](https://haraldoalbergaria.page/map/) on where it is possible to see the locations where each photo uploaded to [my _Flickr_ account](https://www.flickr.com/photos/hpfilho/) have been taken.

[![Photos Map](https://github.com/HaraldoFilho/haraldoalbergaria.page/blob/master/img/map.png)](https://haraldoalbergaria.page/map/)

### Map Data

The map data is generated using the script [FlickrMap](https://github.com/hpfilho/flickr-map), writen in _**Python**_. This script uses the [_Flickr API_](https://www.flickr.com/services/api/)
to get the photos data. It generates the following files:

- **locations.py**: Contains all the markers information, as coordinates and photos attached to them.
- **countries.py**: List of countries where the photos were taken, including number of places and photos for each place.
- **user.py**: Basic user information, such as user id, name, avatar url, photostream url, number of markers and photos on map.

The data on these files are read by a _**Javascript**_ code embedded in a html page, which loads the map. The panel and other customizations are coded in separated _**Javascript**_ and _**CSS**_ files.

### Map Renderization

The map is provided by [_Mapbox_](https://www.mapbox.com/), using its [_Mapbox GL JS API_](https://docs.mapbox.com/mapbox-gl-js/api/) to populate it with the markers data.
