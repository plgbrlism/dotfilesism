#!/usr/bin/env bash
set -euo pipefail
# usage: ./install.sh [niri] [sway] — no args = all. dispatcher needs no packages.
apps=("$@"); [ "$#" -eq 0 ] && apps=(niri sway)
# shared capture + xwayland tools
sudo pacman -S --needed --noconfirm grim slurp wl-clipboard xwayland-satellite
for a in "${apps[@]}"; do
  case "$a" in
    niri) sudo pacman -S --needed --noconfirm niri ;;
    sway)
      sudo pacman -S --needed --noconfirm swaybg swaylock
      command -v yay >/dev/null || { echo "error: yay missing" >&2; exit 1; }
      yay -S --needed --noconfirm swayfx
      ;;
    *) echo "error: unknown app '$a' (niri sway)" >&2; exit 1 ;;
  esac
done
