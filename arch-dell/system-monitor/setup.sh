#!/usr/bin/env bash
set -euo pipefail
# stow btop fastfetch -> $HOME
# usage: ./setup.sh [btop] [fastfetch] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(btop fastfetch)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
for a in "${apps[@]}"; do
  case "$a" in
    btop) [ -e "$HOME/.config/btop" ] && [ ! -L "$HOME/.config/btop" ] && mv "$HOME/.config/btop" "$HOME/.config/btop.bak" ;;
    fastfetch) [ -e "$HOME/.config/fastfetch" ] && [ ! -L "$HOME/.config/fastfetch" ] && mv "$HOME/.config/fastfetch" "$HOME/.config/fastfetch.bak" ;;
    *) echo "error: unknown app '$a' (btop fastfetch)" >&2; exit 1 ;;
  esac
done
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
