# hyprware dotfiles

catppuccin mocha · hyprland · skywareOS

## structure

```
~/.config/
├── hypr/
│   ├── hyprland.conf       # main config — keybinds, rules, animations
│   ├── hyprlock.conf       # lockscreen — blurred wallpaper + clock
│   ├── hypridle.conf       # auto-dim → lock → screen off → suspend
│   ├── colors.conf         # catppuccin mocha palette variables
│   └── scripts/
│       ├── wallpaper.sh    # random wallpaper with swww transitions
│       ├── screenshot.sh   # rofi screenshot menu + annotation
│       ├── volume.sh       # volume control with dunst OSD bar
│       └── brightness.sh   # brightness control with dunst OSD bar
├── waybar/
│   ├── config.jsonc        # modules and layout
│   ├── style.css           # catppuccin mocha styling
│   └── colors.css          # CSS variables
├── rofi/
│   ├── config.rasi         # rofi config
│   ├── theme.rasi          # catppuccin mocha theme
│   └── scripts/
│       └── powermenu.sh    # shutdown/reboot/lock/suspend/logout
├── dunst/
│   └── dunstrc             # notification styling + per-app overrides
└── kitty/
    └── kitty.conf          # terminal + colors + keybinds
```

## install

```bash
git clone https://github.com/SkywareSW/hyprware
cd hyprware
chmod +x install.sh
./install.sh
```

## after install

1. add a wallpaper at `~/.config/hypr/wallpaper.png`
   - or drop multiple `.png/.jpg` files in `~/Pictures/wallpapers/` for random cycling
2. run `hyprctl monitors` and update the monitor line in `hyprland.conf`
3. set your timezone in `waybar/config.jsonc`
4. log out and select hyprland from SDDM

## features

| feature | detail |
|---------|--------|
| lockscreen | blurred wallpaper, live clock, catppuccin input field |
| auto-lock | dim at 2.5min → lock at 5min → screen off at 6min → suspend at 30min |
| wallpaper | random cycle from `~/Pictures/wallpapers/` with animated swww transitions |
| screenshots | full / region / window / annotate via rofi menu |
| volume OSD | dunst bar notification on volume change |
| brightness OSD | dunst bar notification on brightness change |
| clipboard | `SUPER+C` opens cliphist clipboard history in rofi |
| power menu | `SUPER+SHIFT+ESC` — shutdown / reboot / lock / suspend / logout |
| scratchpad | `SUPER+S` toggles a hidden floating workspace |
| media keys | play/pause, next, previous via playerctl |

## keybinds

| keys | action |
|------|--------|
| `SUPER + Return` | open kitty |
| `SUPER + Space` | rofi launcher |
| `SUPER + Q` | close window |
| `SUPER + F` | fullscreen |
| `SUPER + V` | toggle float |
| `SUPER + H/J/K/L` | focus movement |
| `SUPER + SHIFT + H/J/K/L` | move window |
| `SUPER + 1-9` | switch workspace |
| `SUPER + SHIFT + 1-9` | move to workspace |
| `SUPER + CTRL + 1-5` | move silently to workspace |
| `SUPER + Tab` | next workspace |
| `SUPER + R` | resize mode (then H/J/K/L) |
| `SUPER + S` | toggle scratchpad |
| `SUPER + C` | clipboard history |
| `SUPER + B` | open browser |
| `SUPER + E` | open files |
| `SUPER + Escape` | lock screen |
| `SUPER + SHIFT + Escape` | power menu |
| `SUPER + SHIFT + W` | cycle wallpaper |
| `SUPER + CTRL + R` | reload config |
| `SUPER + SHIFT + E` | exit hyprland |
| `Print` | screenshot full |
| `SUPER + SHIFT + S` | screenshot region → clipboard |
| `SUPER + Print` | screenshot window |
| `SUPER + SHIFT + Print` | screenshot + annotate |
