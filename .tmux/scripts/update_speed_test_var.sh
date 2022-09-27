#!/bin/bash

function set_var(){
	val="`tmux show -g @tmux_my_speedtest | cut -d" " -f2`"
	if [[ "$val" == "off" ]]; then
		tmux set -g @tmux_my_speedtest "on" 
	else
		tmux set -g @tmux_my_speedtest "off" 
	fi
}

set_var
