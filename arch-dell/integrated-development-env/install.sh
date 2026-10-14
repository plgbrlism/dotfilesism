#!/usr/bin/env bash
set -euo pipefail
# usage: ./install.sh [nvim] [zed] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(nvim zed)
for a in "${apps[@]}"; do
  case "$a" in
    nvim) sudo pacman -S --needed --noconfirm neovim ;;
    zed) sudo pacman -S --needed --noconfirm zed ;;
    *) echo "error: unknown app '$a' (nvim zed)" >&2; exit 1 ;;
  esac
done
