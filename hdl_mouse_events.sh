#!/bin/bash

winid=$1
logfile=~/conky/cache/gallery.log
curfolder=~/conky/cache/gallery.list

function hdl_mouse_event {
  evt_line=$1
  evt=$(echo $evt_line | cut -d" " -f1)
  case $evt in
    EnterNotify)
      #echo "Gallery entered. Display mouseover with gallery actions and information."
    ;;
    LeaveNotify)
      #echo "Gallery left. Remove mouseover."
    ;;
    ButtonPress)
      #echo "Button pressed...ignore..."
    ;;
    ButtonRelease)
      #echo "Button released...checkout where and take action..."
      button=$(echo $evt_line | cut -d"," -f13 | tr -d ' ')
      coord=$(echo $evt_line | cut -d"," -f8-9 | tr -d '( )')
      if [ "$button" == 'button1' ];then
        file=$(tail -n 1 "$logfile")

        #eog has scrollbars in fullscreen while zoomed
        #eog -fgw "$file" 2>&1 &

        #gthumb not allowing "only one instance" -.-
        #gthumb -f "$file" 2>&1 &

        ls -d1 "$(dirname "$file")"/* > "$curfolder"
        #feh works fine, but keyboard has to be remapped in ~/.config/feh/keys
        if pgrep -x feh > /dev/null; then
          killall feh
        fi
        #filelist=$logfile
        filelist=$curfolder
        feh -ZF --action "nautilus %F" --zoom fill -f "$filelist" --start-at "$file" 2>&1 >> /var/log/conky.log &
        #feh -ZF --zoom fill "$file" 2>&1 >> /var/log/conky.log &
        echo "feh started with $file"
      fi
    ;;
    *)
      #if debug...:
      #echo $evt_line
    ;;
  esac
}

# modify multiline-xev-input
input=""
xev -id "$winid" | (while read line; do
  input+="$line"
  # focus needed for leavenotify..."leave" will be thrown on "enter" if waiting for empty line...
  # state needed for buttonpress|buttonrelease
  if [[ "$line" =~ ^$ ]] || [[ "$line" =~ ^focus.*$ ]] || [[ "$line" =~ ^state.*$ ]]; then
    if [[ "$input" =~ ^.+$ ]]; then
      hdl_mouse_event "$input"
    fi
    input=""
  fi
done)
