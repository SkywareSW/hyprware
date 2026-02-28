#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — scripts/brightness.sh
#  brightness control with OSD notification
# ─────────────────────────────────────────

notify_brightness() {
    BRIGHT=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')

    if [[ $BRIGHT -lt 30 ]]; then
        ICON="󰃞"
    elif [[ $BRIGHT -lt 70 ]]; then
        ICON="󰃟"
    else
        ICON="󰃠"
    fi

    FILLED=$(( BRIGHT / 5 ))
    BAR=""
    for ((i=0; i<20; i++)); do
        if [[ $i -lt $FILLED ]]; then
            BAR+="█"
        else
            BAR+="░"
        fi
    done

    notify-send \
        -h string:x-dunst-stack-tag:brightness \
        -h int:value:"$BRIGHT" \
        --urgency=low \
        --expire-time=1500 \
        "$ICON  brightness" \
        "$BAR  $BRIGHT%"
}

case "$1" in
    up)
        brightnessctl set +10%
        notify_brightness
        ;;
    down)
        brightnessctl set 10%-
        notify_brightness
        ;;
    *)
        echo "usage: $0 up|down"
        ;;
esac
