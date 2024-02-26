#!/usr/bin/env bash
dunst &
waybar &
swww init &&
swww img $HOME/.local/share/wallpapers/11.gif &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

#discord --start-minimized &

# other
notify-send -a aurora "hello $(whoami)" &

#cd /home/fahim/Documents/starpage/ && python -m http.server && cd &
