#!/usr/bin/env bash
set -euo pipefail
# pkgs: niri swaybg swaylock grim slurp wl-clipboard xwayland-satellite | aur: swayfx
sudo pacman -S --needed --noconfirm niri grim slurp wl-clipboard xwayland-satellite
command -v yay >/dev/null || { echo "error: yay missing" >&2; exit 1; }
yay -S --needed --noconfirm swayfx
