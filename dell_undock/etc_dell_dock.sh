#!/bin/bash 

usr="$(last | head | grep -v ":0.0" | grep -v pts | grep -v system | grep -m1 still | cut -d" " -f1 | uniq)"

lastnum=$(cat /root/displaycount)
currnum=$(su -c "DISPLAY=:0 xrandr -q | grep ' connected' | wc -l" - "$usr")
echo -n $currnum > /root/displaycount

if [ "$lastnum" != "$currnum" ]; then
	echo "monitor setup changed: $currnum :: $lastnum" >> /root/dockingstate.log

	# kill mouse handler
	proc=$(ps aux | grep hdl_mouse_events | grep -v grep | tr -s " " | cut -d" " -f2); [[ "$proc" =~ ^.+$ ]] && echo $proc | xargs kill

	# kill conky
	if pgrep -x conky > /dev/null; then
	  echo "is running..." >> /var/log/conky.log
	  killall conky
	  echo "killed" >> /var/log/conky.log
	fi

	sleep 15

	su -l "$usr" -c "DISPLAY=:0 /home/${usr}/conky-sidebar/conky.sh &" >> /root/dockingstate.log 2>&1

	echo "restarted conky for $usr" >> /root/dockingstate.log
fi

exit 0
