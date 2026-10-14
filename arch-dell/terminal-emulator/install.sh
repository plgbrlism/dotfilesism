#!/usr/bin/env bash
set -euo pipefail
# usage: ./install.sh [foot] [kitty] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(foot kitty)
for a in "${apps[@]}"; do
  case "$a" in
    foot) sudo pacman -S --needed --noconfirm foot ;;
    kitty) sudo pacman -S --needed --noconfirm kitty ;;
    *) echo "error: unknown app '$a' (foot kitty)" >&2; exit 1 ;;
  esac
done
