#!/bin/bash 

usr="$(last | head | grep -v ":0.0" | grep -v pts | grep -v system | grep -m1 still | cut -d" " -f1 | uniq)" 

su -c "export DISPLAY=:0; /home/${usr}/conky/conky.sh &" - ${usr} >> /root/dockingstate.log 2>&1

echo "restarted conky" >> /root/dockingstate.log

case "$1" in 
	"remove") 
		#undocked event
		echo "undocked $usr" >> /root/dockingstate.log
	;;
	"add") 
		#docked event
		echo "docked $usr" >> /root/dockingstate.log
	;;
	*)
		#unknown
		echo "unknown $usr" >> /root/dockingstate.log
	;;
esac

exit 0
