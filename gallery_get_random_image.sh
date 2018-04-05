#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

logfile="$conkydir"/cache/gallery.log

if [ -f "$gallery" ]; then
  list=$(cat "$gallery" | sed "s|^\.|$(dirname $gallery)|g")
else
  list=$(find -L "$gallery" -type f)
fi

echo "$list" | shuf | while read file; do
  file="$file"
  data=$(file -b "$file")
  if [ $(echo $data | awk '{print $2}') == 'image' -a `identify "$file" | wc -l` -eq 1 ]; then
    "$conkydir"/gallery_create_thumbnail.sh "$file"
    echo "$file" >> "$logfile"
    tail -n 100 "$logfile" > "${logfile}.tmp" && mv "${logfile}.tmp" "$logfile"
    break
  fi
done
exit 0
