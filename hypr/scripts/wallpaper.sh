#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — scripts/wallpaper.sh
#  cycle wallpapers with swww transitions
# ─────────────────────────────────────────

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_FILE="$HOME/.cache/hyprware/last_wallpaper"

mkdir -p "$(dirname "$CACHE_FILE")"

# pick a random wallpaper (different from last)
pick_random() {
    local last=""
    [[ -f "$CACHE_FILE" ]] && last=$(cat "$CACHE_FILE")

    local walls=()
    while IFS= read -r -d $'\0' f; do
        walls+=("$f")
    done < <(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) -print0)

    if [[ ${#walls[@]} -eq 0 ]]; then
        echo "no wallpapers found in $WALLPAPER_DIR" >&2
        exit 1
    fi

    local chosen="${walls[RANDOM % ${#walls[@]}]}"
    # avoid repeating the same wallpaper if more than one exists
    if [[ ${#walls[@]} -gt 1 ]]; then
        while [[ "$chosen" == "$last" ]]; do
            chosen="${walls[RANDOM % ${#walls[@]}]}"
        done
    fi
    echo "$chosen"
}

# transitions (pick one randomly for variety)
TRANSITIONS=(
    "fade"
    "left"
    "right"
    "top"
    "bottom"
    "wipe"
    "grow"
    "center"
)

TRANSITION="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"

WALLPAPER=$(pick_random)
echo "$WALLPAPER" > "$CACHE_FILE"

swww img "$WALLPAPER" \
    --transition-type "$TRANSITION" \
    --transition-duration 1.5 \
    --transition-fps 144 \
    --transition-bezier "0.25,1,0.5,1"

# send notification
notify-send \
    --icon=image-x-generic \
    --urgency=low \
    "wallpaper changed" \
    "$(basename "$WALLPAPER")"
