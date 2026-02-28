#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — rofi/scripts/powermenu.sh
# ─────────────────────────────────────────

shutdown="󰐥 shutdown"
reboot="󰜉 reboot"
lock="󰌾 lock"
suspend="󰒲 suspend"
logout="󰍃 logout"

chosen=$(printf '%s\n' "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi \
    -dmenu \
    -p "  power" \
    -theme ~/.config/rofi/theme.rasi \
    -no-show-icons \
    -i)

case "$chosen" in
    "$shutdown")  systemctl poweroff ;;
    "$reboot")    systemctl reboot ;;
    "$lock")      hyprlock ;;
    "$suspend")   systemctl suspend ;;
    "$logout")    hyprctl dispatch exit ;;
esac
