SCREENSHOT_DIR="${XDG_PICTURES_DIR:-$HOME/pictures}"/screenshots
SCREENSHOT_FILE=$(date +'%Y-%m-%d-%H-%M-%S-%s.png')

if [[ -z $1 ]]; then
  grim "$SCREENSHOT_DIR/$SCREENSHOT_FILE"  
elif [[ $1 = "select" ]]; then
  slurp | grim -g - "$SCREENSHOT_DIR/$SCREENSHOT_FILE"
else
  echo 'Wrong argument'
  exit 1
fi

notify-send -i "$SCREENSHOT_DIR/$SCREENSHOT_FILE" "Screenshot Saved" "$SCREENSHOT_DIR/$SCREENSHOT_FILE"
wl-copy < "$SCREENSHOT_DIR/$SCREENSHOT_FILE"
