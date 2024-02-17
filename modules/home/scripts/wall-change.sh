if [[ -z "$1" ]]; then
  IMAGE="$(imv "${XDG_DATA_HOME:-$HOME/.local/share}"/wallpapers -r -w imv-wallpaper-change -c 'bind <Return> exec echo $imv_current_file; quit')"
else
  IMAGE=$1
fi 
swww img "$IMAGE" --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 3
