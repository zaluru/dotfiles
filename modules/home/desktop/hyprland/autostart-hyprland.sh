#!/usr/bin/env bash
dunst &
waybar &
swww init &&
swww img "${XDG_DATA_HOME:-$HOME/.local/share}"/bg &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

#discord --start-minimized &

# other
notify-send -a aurora "hello $(whoami)" &

#cd /home/fahim/Documents/starpage/ && python -m http.server && cd &
