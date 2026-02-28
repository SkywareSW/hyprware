#!/usr/bin/env bash
# ─────────────────────────────────────────
#  hyprware — install.sh
#  dotfiles installer for skywareOS
# ─────────────────────────────────────────

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config.bak.$(date +%s)"

log()  { echo -e "\033[1;34m[hyprware]\033[0m $1"; }
ok()   { echo -e "\033[1;32m[  done  ]\033[0m $1"; }
warn() { echo -e "\033[1;33m[  warn  ]\033[0m $1"; }
err()  { echo -e "\033[1;31m[  err   ]\033[0m $1" && exit 1; }

echo ""
echo -e "\033[1;35m  hyprware dotfiles\033[0m"
echo -e "\033[2m  catppuccin mocha · skywareOS\033[0m"
echo ""

# ── 01 check system ──────────────────────
log "checking system..."
[[ "$(uname -s)" == "Linux" ]] || err "linux only"
command -v pacman &>/dev/null   || err "pacman not found — are you on skywareOS/arch?"
ok "system check passed"

# ── 02 install packages ──────────────────
log "installing packages..."

PKGS=(
    # wayland / hyprland
    hyprland
    hyprlock
    hypridle
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    polkit-gnome
    qt5-wayland
    qt6-wayland

    # bar, launcher, notifications
    waybar
    rofi-wayland
    dunst
    libnotify

    # terminal
    kitty

    # wallpaper
    swww

    # screenshots + annotation
    grim
    slurp
    swappy
    wl-clipboard

    # clipboard manager
    cliphist

    # fonts
    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji
    ttf-font-awesome

    # icons + cursor
    papirus-icon-theme
    catppuccin-cursors-mocha

    # audio
    pipewire
    wireplumber
    pipewire-pulse
    pamixer
    pavucontrol

    # media control
    playerctl

    # brightness (laptop)
    brightnessctl

    # file manager
    thunar

    # tools
    jq
    bc

    # display manager
    sddm
)

sudo pacman -Syu --needed --noconfirm "${PKGS[@]}"
ok "packages installed"

# ── 03 backup existing configs ───────────
log "backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

for dir in hypr waybar rofi dunst kitty; do
    if [[ -d "$CONFIG_DIR/$dir" ]]; then
        cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
        warn "backed up: ~/.config/$dir"
    fi
done
ok "backup complete"

# ── 04 link dotfiles ─────────────────────
log "copying dotfiles to ~/.config/..."

for dir in hypr waybar rofi dunst kitty; do
    if [[ -d "$DOTFILES_DIR/$dir" ]]; then
        mkdir -p "$CONFIG_DIR/$dir"
        cp -r "$DOTFILES_DIR/$dir/." "$CONFIG_DIR/$dir/"
        ok "linked: $dir"
    else
        warn "skipping $dir (not found in dotfiles)"
    fi
done

# make all scripts executable
chmod +x "$CONFIG_DIR/rofi/scripts/powermenu.sh"     2>/dev/null || true
chmod +x "$CONFIG_DIR/hypr/scripts/wallpaper.sh"     2>/dev/null || true
chmod +x "$CONFIG_DIR/hypr/scripts/screenshot.sh"    2>/dev/null || true
chmod +x "$CONFIG_DIR/hypr/scripts/volume.sh"        2>/dev/null || true
chmod +x "$CONFIG_DIR/hypr/scripts/brightness.sh"    2>/dev/null || true

# ── 05 enable SDDM ───────────────────────
log "enabling SDDM..."
sudo systemctl enable sddm.service
ok "SDDM enabled"

# ── 06 enable audio services ─────────────
log "enabling audio..."
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
ok "audio services enabled"

# ── 07 wallpaper placeholder ─────────────
log "setting up wallpaper directory..."
mkdir -p "$HOME/Pictures/wallpapers"
if [[ ! -f "$CONFIG_DIR/hypr/wallpaper.png" ]]; then
    warn "no wallpaper found — add one at ~/.config/hypr/wallpaper.png"
    warn "or drop .png files in ~/Pictures/wallpapers/ and update hyprland.conf"
fi

# ── done ─────────────────────────────────
echo ""
echo -e "\033[1;35m  hyprware installed successfully!\033[0m"
echo ""
echo -e "\033[2m  next steps:\033[0m"
echo -e "\033[2m  1. add a wallpaper at ~/.config/hypr/wallpaper.png\033[0m"
echo -e "\033[2m  2. update monitor name in ~/.config/hypr/hyprland.conf\033[0m"
echo -e "\033[2m  3. set your timezone in ~/.config/waybar/config.jsonc\033[0m"
echo -e "\033[2m  4. log out and select hyprland from SDDM\033[0m"
echo ""
