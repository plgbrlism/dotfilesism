#!/usr/bin/env bash
set -euo pipefail
# usage: ./install.sh [btop] [fastfetch] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(btop fastfetch)
for a in "${apps[@]}"; do
  case "$a" in
    btop) sudo pacman -S --needed --noconfirm btop ;;
    fastfetch) sudo pacman -S --needed --noconfirm fastfetch ;;
    *) echo "error: unknown app '$a' (btop fastfetch)" >&2; exit 1 ;;
  esac
done
