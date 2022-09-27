#!/bin/bash

val="`tmux show -g @tmux_my_speedtest | cut -d" " -f2`"
if [[ "$val" == "on" ]]; then
	s=`speedtest --simple | tr -s '\n' ':'`
	if [ "$s" == "" ]; then
		echo "Currently offline"
	else
		python_cmd="\
s=input();\
l=s.split(':');\
ping=l[1].strip();\
ping=ping.split('.')[0]+' ms';\
down=l[3].strip();\
down=down.split(' ')[0]+' Mbps';\
up=l[5].strip();\
up=up.split(' ')[0]+' Mbps';\
print('🏓: '+ping, ' :', down, ' :' ,up)"
		echo "$s" | python -c "$python_cmd"
	fi
else
	echo "Speed test disabled"
fi

sleep 60
	
