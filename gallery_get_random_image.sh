#!/bin/bash

gallery=~/Path/to/your/images
#gallery=~/path/to/filelist/files.list

logfile=~/conky-sidebar/cache/gallery.log

if [ -f "$gallery" ]; then
  list=$(cat "$gallery" | sed "s|^\.|$(dirname $gallery)|g")
else
  list=$(find -L "$gallery" -type f)
fi

echo "$list" | shuf | while read file; do
  file="$file"
  data=$(file -b "$file")
  if [ $(echo $data | awk '{print $2}') == 'image' ]; then
    ~/conky-sidebar/gallery_create_thumbnail.sh "$file"
    echo "$file" >> "$logfile"
    tail -n 100 "$logfile" > "${logfile}.tmp" && mv "${logfile}.tmp" "$logfile"
    break
  fi
done
exit 0
