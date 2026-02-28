#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — scripts/screenshot.sh
#  smart screenshot with rofi menu
# ─────────────────────────────────────────

SAVE_DIR="$HOME/Pictures/screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

case "$1" in
    full)
        grim "$SAVE_DIR/screenshot-$TIMESTAMP.png"
        notify-send "📸 screenshot saved" "$SAVE_DIR/screenshot-$TIMESTAMP.png" --urgency=low
        ;;
    region)
        grim -g "$(slurp -d)" - | tee "$SAVE_DIR/screenshot-$TIMESTAMP.png" | wl-copy
        notify-send "📸 region screenshot" "saved + copied to clipboard" --urgency=low
        ;;
    window)
        FOCUSED=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$FOCUSED" - | tee "$SAVE_DIR/screenshot-$TIMESTAMP.png" | wl-copy
        notify-send "📸 window screenshot" "saved + copied to clipboard" --urgency=low
        ;;
    edit)
        grim -g "$(slurp -d)" - | swappy -f -
        ;;
    *)
        # rofi menu to pick mode
        CHOICE=$(printf 'full screen\nregion\nwindow\nedit (annotate)' | rofi \
            -dmenu \
            -p "📸 screenshot" \
            -theme ~/.config/rofi/theme.rasi \
            -no-show-icons \
            -i)

        case "$CHOICE" in
            "full screen")   "$0" full ;;
            "region")        "$0" region ;;
            "window")        "$0" window ;;
            "edit (annotate)") "$0" edit ;;
        esac
        ;;
esac
