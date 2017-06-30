#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

srcfile="$1"
tmpfile="$conkydir"/cache/gallery_tmp.png
tgtfile="$conkydir"/cache/gallery.png

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
  if [ -f "$tmpfile" ]; then
    rm -f "$tmpfile"
  fi
  convert -regard-warnings "$srcfile" -resize 180 -background none -gravity $gravity -extent 180x135 PNG24:$tmpfile
  if [ -f "$tgtfile" ]; then
    rm -f "$tgtfile"
  fi
  mv "$tmpfile" "$tgtfile"
  if [ $? -ne 0 ]; then
    echo $srcfile >> /var/log/conky.log
  fi
fi
exit 0

