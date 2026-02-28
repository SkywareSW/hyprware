#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — scripts/volume.sh
#  volume control with OSD notification
# ─────────────────────────────────────────

notify_volume() {
    VOL=$(pamixer --get-volume)
    MUTED=$(pamixer --get-mute)

    if [[ "$MUTED" == "true" ]]; then
        ICON="󰝟"
        MSG="muted"
    elif [[ $VOL -lt 30 ]]; then
        ICON="󰕿"
        MSG="$VOL%"
    elif [[ $VOL -lt 70 ]]; then
        ICON="󰖀"
        MSG="$VOL%"
    else
        ICON="󰕾"
        MSG="$VOL%"
    fi

    # build a simple bar out of unicode blocks
    FILLED=$(( VOL / 5 ))
    BAR=""
    for ((i=0; i<20; i++)); do
        if [[ $i -lt $FILLED ]]; then
            BAR+="█"
        else
            BAR+="░"
        fi
    done

    notify-send \
        -h string:x-dunst-stack-tag:volume \
        -h int:value:"$VOL" \
        --urgency=low \
        --expire-time=1500 \
        "$ICON  volume" \
        "$BAR  $MSG"
}

case "$1" in
    up)
        pamixer -i 5
        [[ $(pamixer --get-volume) -gt 100 ]] && pamixer --set-volume 100
        notify_volume
        ;;
    down)
        pamixer -d 5
        notify_volume
        ;;
    mute)
        pamixer -t
        notify_volume
        ;;
    *)
        echo "usage: $0 up|down|mute"
        ;;
esac
