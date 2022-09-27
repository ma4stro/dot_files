#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '︽')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '︾')
session_icon="$(tmux_get '@tmux_power_session_icon' '💻')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"





battery_icon="$(tmux_get '@tmux_battery_icon' '🍺')"


time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '🗓️ ')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')
# short for Theme-Colour
speedtest=`tmux show -gqv @tmux_my_speedtest`
TC=$(tmux_get '@tmux_power_theme' 'gold')
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
BG="$G03"

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# copy mode
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_not_highlight_fg "$G04"
tmux_set @prefix_not_highlight_bg "$TC"
tmux_set @prefix_highlight_empty_has_affixes 'on'
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"
# not typed prefixes
tmux_set @prefix_not_highlight_output_prefix "#[fg=$G04]#[bg=$BG]$left_arrow_icon#[bg=$G04]#[fg=$TC]"
tmux_set @prefix_not_highlight_output_suffix "#[fg=$G04]#[bg=$BG]$right_arrow_icon"
#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "$G12"
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$TC,bg=$BG,nobold]$left_arrow_icon\
#[fg=$G04,bg=$TC,bold]$user_icon #(/usr/bin/whoami)#[fg=$TC,bg=$BG,nobold]$right_arrow_icon \
#[fg=$G06,bg=$BG,nobold]$left_arrow_icon\
#[fg=$TC,bg=$G06]$session_icon #S\
#[fg=$G06,bg=$BG,nobold]$right_arrow_icon \
#[fg=$G05,bg=$BG,nobold]$left_arrow_icon\
#[fg=$TC,bg=$G05,nobold] RAM: #(/usr/local/bin/tmux-mem --format '[#[fg=:color]:spark#[fg=$TC,bg=$G05,nobold]] #[fg=:color]:percent#[default]')\
#[fg=$TC,bg=$G05,nobold] \
#[fg=$TC,bg=$G05,nobold] CPU: #(/usr/local/bin/tmux-cpu --format '[#[fg=:color]:spark#[fg=$TC,bg=$G05,nobold]] #[fg=:color]:percent')\
#[fg=$G05,bg=$BG,nobold]$right_arrow_icon \
"

if [[ "$speedtest" == "on" ]]; then
LS="$LS#[fg=$G04,bg=$BG,nobold]$left_arrow_icon\
#[fg=$TC,bg=$G04,nobold]#(/home/luca/.tmux/scripts/speedtest.sh) \
#[fg=$G04,bg=$BG,nobold]$right_arrow_icon"
else
LS="$LS#[fg=$G04,bg=$BG,nobold]$left_arrow_icon\
#[fg=$TC,bg=$G04,nobold]Speedtest disabled \
#[fg=$G04,bg=$BG,nobold]$right_arrow_icon"
fi


if "$show_upload_speed"; then
    LS="$LS#[fg=$G06,bg=$G05]$right_arrow_icon#[fg=$TC,bg=$G05] $upload_speed_icon #{upload_speed} #[fg=$G05,bg=$BG]$right_arrow_icon"
#else
#    LS="$LS#[fg=$G05,bg=$BG]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$G04"
tmux_set status-right-fg "$G12"
tmux_set status-right-length 150
RS="#[fg=$BG,bg=$BG]$left_arrow_icon#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$G05,bg=$G05]$battery_icon #[fg=$TC,bg=$G05]#{battery_percentage}\
#[fg=$G05,bg=$BG]$right_arrow_icon \
#[fg=$G06,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G06] #{weather} \
#[fg=$G06,bg=$BG]$right_arrow_icon \
#[fg=$TC,bg=$BG]$left_arrow_icon#[fg=$G04,bg=$TC]$time_icon $time_format\
#[fg=$G04,bg=$TC]  #[fg=$G04,bg=$TC]$date_icon $date_format#[fg=$TC,bg=$BG,nobold]$right_arrow_icon\
" 
#[fg=$TC,bg=$G04]$left_arrow_icon#[fg=$G04,bg=$TC] $date_icon $date_format "

if "$show_download_speed"; then
    RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} #[fg=$G06,bg=$G05]$left_arrow_icon$RS"
fi
if "$show_web_reachable"; then
    RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format "#[bg=$BG] #[fg=$G01,bg=$BG]$left_arrow_icon#[fg=#00afff,bg=$G01]#I:#W #[fg=$TC,bg=$G01,bold]#F#[fg=$G01,bg=$BG]$right_arrow_icon"
tmux_set window-status-current-format "#[bg=$BG] #[fg=$G06,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G06,bold] #I:#W #[fg=$G06,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-statys "fg=$TC,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$G07,bg=default"

# Active pane border
tmux_set pane-active-border-style "fg=$TC,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
