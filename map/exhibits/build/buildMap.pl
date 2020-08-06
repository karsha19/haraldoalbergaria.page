#!/usr/bin/perl

#
#  File          : buildMap.pl
#  Last modified : 07/20/20 6:55 PM
#
#  Developer     : Haraldo Albergaria Filho
#
#  Description   : Script to create exhibits map
#  Usage         : buildMap.pl
#
#  --------------------------------------------------------------

my $countries_file  = "countries.csv";
my $galleries_file  = "galleries.csv";
my $exhibits_file   = "exhibits.csv";
my $stats_file      = "statscounter";
my $map_file        = "map.html";
my $index_file      = "../index.html";

if (not -f $countries_file) {
  die "There is no countries file! Please, create one and run again.\n";
}

if (not -f $galleries_file) {
  die "There is no galleries file! Please, create one and run again.\n";
}

if (not -f $exhibits_file) {
  die "There is no exhibits file! Please, create one and run again.\n";
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

open GALLERIES_FILE, "$galleries_file" or die "Can't open $galleries_file to read: $!\n";
my @galleries = <GALLERIES_FILE>;
close GALLERIES_FILE;

open EXHIBITS_FILE, "$exhibits_file" or die "Can't open $exhibits_file to read: $!\n";
my @exhibits = <EXHIBITS_FILE>;
close EXHIBITS_FILE;

open STATS_FILE, "$stats_file" or die "Can't open $stats_file to read: $!\n";
my @stats_lines = <STATS_FILE>;
close STATS_FILE;

open MAP_FILE, "$map_file" or die "Can't open $map_file to read: $!\n";
my @map_file_lines = <MAP_FILE>;
close MAP_FILE;

open INDEX_FILE, ">$index_file" or die "Can't open $index_file to write: $!\n";

foreach (@map_file_lines) {
  if ( m/function\sgetLocations/ ) {
    for (my $i = 1; $i < @countries; $i++) {
      $countries[$i] =~ /(.+),(.+),(.+),(.+),(.+)/;
      $west = $2; 
      $south = $3;
      $east = $4;
      $north = $5;
      $func = $1;
      $func =~ s/\s//;
      print INDEX_FILE "  function show$func() {\n";
      print INDEX_FILE "    map.fitBounds([\n";
      print INDEX_FILE "      [$west, $south],\n";
      print INDEX_FILE "      [$east, $north]\n";
      print INDEX_FILE "    ])\;\n";
      print INDEX_FILE "  }\;\n\n";
    }
  }
  if ( m/<\/body>/ ) {
    foreach  (@stats_lines) {
      print INDEX_FILE $_;
    }
    print INDEX_FILE "\n";
  }
  print INDEX_FILE $_;
  if ( m/exhibits-countries-panel/ ) {
    for (my $i = @countries-1; $i > 0; $i--) {
      $countries[$i] =~ /(.+),(.+),(.+),(.+),(.+)/;
      $country = $1;
      $icon = $1;
      $func = $1;
      $icon =~ s/\s/-/;
      $icon = lc $icon.".svg";
      $func =~ s/\s//;
      print INDEX_FILE "    <div class=\"flag-icon\"><img class=\"icon\" src=\"../icons/$icon\" title=\"$country\" alt=\"$country\" onclick=\"show$func()\"/></div>\n";
    }
  }
  if ( m/var\slocations\s=\s\[\]/ ) {
    for (my $i = 1; $i < @galleries; $i++) {
      $galleries[$i] =~ /(.+),(.+),(.+),(.+),(.+),(.+)/;
      my $gallery = $1;
      my $gallery_exhibits = "[[$4, $5], \"<div class=\\\"exhibition\\\"><div class=\\\"gallery-name\\\"><a class=\\\"exhib\\\" href=\\\"$6\\\" target=\\\"_blank\\\">$1</a></div>";
      for (my $i = @exhibits-1; $i > 0; $i--) {
        $exhibits[$i] =~ /(.+),.+/;
        if ( $1 =~ $gallery) {
          $exhibits[$i] =~ /(.+),(.+),(.+),(.+)/;
          $gallery_exhibits = $gallery_exhibits."<div class=\\\"exhibition-name\\\"><a class=\\\"exhib\\\" href=\\\"$4\\\" target=\\\"_blank\\\">$2 $3</a></div>";
        }
      }
      $gallery_exhibits = $gallery_exhibits."</div>\"]";
      print INDEX_FILE "    locations.push($gallery_exhibits);\n";
    }
  }
}
