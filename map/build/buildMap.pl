#!/usr/bin/perl

#
#  File          : buildMap.pl
#  Last modified : 07/20/20 6:55 PM
#
#  Developer     : Haraldo Albergaria Filho
#
#  Description   : Script to create Flickr's photos map
#  Usage         : buildMap.pl
#
#  --------------------------------------------------------------

my $countries_file  = "countries.csv";
my $stats_file      = "statscounter";
my $api_file        = "api_key";
my $map_file        = "map.html";
my $index_file      = "../index.html";

if (not -f $countries_file) {
  die "There is no countries file! Please, create one and run again.\n";
}

if (not -f $stats_file) {
  die "There is no stats file! Please, create one and run again.\n";
}

if (not -f $map_file) {
  die "There is no map.html file! Please, create one and run again.\n";
}

open COUNTRIES_FILE, "$countries_file" or die "Can't open $countries_file to read: $!\n";
my @countries = <COUNTRIES_FILE>;
close COUNTRIES_FILE;

open STATS_FILE, "$stats_file" or die "Can't open $stats_file to read: $!\n";
my @stats_lines = <STATS_FILE>;
close STATS_FILE;

open API_FILE, "$api_file" or die "Can't open $api_file to read: $!\n";
my $api_key = <STATS_FILE>;
close API_FILE;

open MAP_FILE, "$map_file" or die "Can't open $map_file to read: $!\n";
my @map_file_lines = <MAP_FILE>;
close MAP_FILE;

open INDEX_FILE, ">$index_file" or die "Can't open $index_file to write: $!\n";

foreach (@map_file_lines) {
  s/<--\sInsert\shere\sthe\sMapbox\sAPI\saccess\stoken\s-->/pk.eyJ1IjoiaGFyYWxkby1maWxobyIsImEiOiJja2NlNmozZ3gwNWdxMnJwaHRveHNuMDE3In0.UFRldAO_nZrNCt6inNHDcQ/g;
  if ( m/\A<\/div>/ ) {
    print INDEX_FILE "</div>\n\n<div class=\"photos-countries-panel\">\n";
    for (my $i = @countries-1; $i > 1; $i--) {
      $countries[$i] =~ /(.+),(.+),(.+),(.+),(.+),(.+)/;
      print INDEX_FILE "    <div class=\"flag-icon\"><img class=\"icon\" src=\"icons/$1\" title=\"$2\" alt=\"$2\" onclick=\"$3()\" /></div>\n";
    }
    print INDEX_FILE "</div>\n\n";
    print INDEX_FILE "<div class=\"map-switcher\">\n";
    print INDEX_FILE "    <div class=\"selected-photos\">PHOTOS</div>\n";
    print INDEX_FILE "    <div class=\"unselected-exhibits\" onclick=\"openExhibits()\">EXHIBITS</div>\n";
    print INDEX_FILE "</div>\n\n";
    print INDEX_FILE "<div class=\"attribution\">\n";
    print INDEX_FILE "    Icons made by <a href=\"https://www.flaticon.com/authors/turkkub\" title=\"turkkub\" target=\"_blank\">turkkub</a> (World) and <a href=\"https://www.flaticon.com/authors/freepik\" title=\"Freepik\">Freepik</a> (Countries) from <a href=\"https://www.flaticon.com/\" title=\"Flaticon\" target=\"_blank\">www.flaticon.com</a>\n";
  }
  if ( m/function\sgetLocations/ ) {
    for (my $i = 2; $i < @countries; $i++) {
      $countries[$i] =~ /(.+),(.+),(.+),(.+),(.+),(.+)/;
      print INDEX_FILE "    function $3() {\n";
      print INDEX_FILE "      map.flyTo({\n";
      print INDEX_FILE "        center: [$4, $5],\n";
      print INDEX_FILE "        zoom: $6\n";
      print INDEX_FILE "      })\;\n";
      print INDEX_FILE "    }\n\n\n";
    }
  }
  if ( m/<\/body>/ ) {
    foreach  (@stats_lines) {
      print INDEX_FILE $_;
    }
    print INDEX_FILE "\n";
  }
  print INDEX_FILE $_;
  if ( m/meta charset="utf-8"/ ) {
    print INDEX_FILE "  <title>Haraldo Albergaria | Photos Map</title>\n";
    print INDEX_FILE "  <link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"../icons/favicon.ico\">\n";
    print INDEX_FILE "  <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />\n";
  }
  if ( m/map\.addControl/ ) {
    print INDEX_FILE "\n    function openExhibits() {\n";
    print INDEX_FILE "        window.location.replace(\"https://hpfilho.github.io/map/exhibits/\")\n";
    print INDEX_FILE "    }\n";
  }
}
