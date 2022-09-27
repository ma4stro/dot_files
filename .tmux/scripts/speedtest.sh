#!/bin/bash

s=`speedtest -f json 2>/dev/null`
if [ "$s" == '' ]; then
	echo "Currently offline"
else
python_cmd="\
s=input();\
from json import loads;\
d=loads(s);\
ping=d['ping']['latency'];\
ping='{:.2f} ms'.format(ping);\
down=d['download']['bandwidth']/125000;\
down='{:.2f} Mbps'.format(down);\
up=d['upload']['bandwidth']/125000;\
up='{:.2f} Mbps'.format(up);\
print('🏓: '+ping, ' :', down, ' :' ,up);"
	#print('🏓: '+ping, '| :', l[3].strip(), '| :' ,l[5].strip())"
	echo "$s" | python -c "$python_cmd"
fi

sleep 60

