#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

if [ ! -d "cache" ];then
  mkdir cache
  touch cache/forecast.json
  touch cache/weather.json
  touch cache/gallery.log
fi

# kill feh, since otherwise conky-gallery-display is broken
if pgrep -x feh > /dev/null; then
  killall feh
  sleep 1
fi

# kill mouse handler
proc=$(ps aux | grep hdl_mouse_events | grep -v grep | tr -s " " | cut -d" " -f2); [[ "$proc" =~ ^.+$ ]] && echo $proc | xargs kill

# kill conky
if pgrep -x conky > /dev/null; then
  echo "is running..." >> /var/log/conky.log
  killall conky
  echo "killed" >> /var/log/conky.log
fi

sleep 2
conky -c "${conkydir}/conky.conf"  >> /var/log/conky.log 2>&1 &

winid=''
while [ "$winid" == "" ]; do
  sleep 0.1
  winid=$(wmctrl -l | grep hidden_conky | cut -d" " -f1)
done
conky -c "${conkydir}/conky_gallery.conf"  >> /var/log/conky.log 2>&1 &

winid=''
while [ "$winid" == "" ]; do
  sleep 0.1
  winid=$(wmctrl -l | grep hidden_conky_gallery | cut -d" " -f1)
done
"${conkydir}"/hdl_mouse_events.sh $winid >> /var/log/conky.log 2>&1 &

exit
