if [[ -z "$1" ]]; then
  IMAGE="$(imv "${XDG_PICTURES_DIR:-$HOME/pictures}"/wallpapers -r -w imv-wallpaper-change -c 'bind <Return> exec echo $imv_current_file; quit')"
else
  IMAGE=$1
fi 

ln -sf "$IMAGE" "${XDG_DATA_HOME:-$HOME/.local/share}"/bg
swww img "${XDG_DATA_HOME:-$HOME/.local/share}"/bg --transition-type grow --transition-pos "$(hyprctl cursorpos)" --transition-duration 3
