#!/bin/bash

srcfile="$1"
tgtfile=~/conky-sidebar/cache/gallery.png

if [ -f "$srcfile" ]; then
  size=$(identify -ping -format '%wx%h' "$srcfile")
  width=$(echo $size | cut -d"x" -f 1)
  height=$(echo $size | cut -d"x" -f 2)
  if [ "$height" -gt "$width" ]; then
    #portrait
    gravity=south
  else
    #landscape
    gravity=center
  fi
  convert -regard-warnings "$srcfile" -resize 180 -background none -gravity $gravity -extent 180x135 PNG24:$tgtfile
  if [ $? -ne 0 ]; then
    echo $srcfile >> /var/log/conky.log
  fi
fi
exit 0

