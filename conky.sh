#!/bin/bash

conkydir=/home/yourname/conky-sidebar

# kill conky
if pgrep -x conky > /dev/null; then
  echo "is running..." >> /var/log/conky.log
  killall conky
  echo "killed" >> /var/log/conky.log
fi

# kill mouse handler
proc=$(ps aux | grep hdl_mouse_events | grep -v grep | tr -s " " | cut -d" " -f2); [[ "$proc" =~ ^.+$ ]] && echo $proc | xargs kill

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
${conkydir}/hdl_mouse_events.sh $winid >> /var/log/conky.log 2>&1 &

exit
