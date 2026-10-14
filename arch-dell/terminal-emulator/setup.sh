#!/usr/bin/env bash
set -euo pipefail
# stow foot kitty -> $HOME
# usage: ./setup.sh [foot] [kitty] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(foot kitty)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
for a in "${apps[@]}"; do
  case "$a" in
    foot) [ -e "$HOME/.config/foot" ] && [ ! -L "$HOME/.config/foot" ] && mv "$HOME/.config/foot" "$HOME/.config/foot.bak" ;;
    kitty) [ -e "$HOME/.config/kitty" ] && [ ! -L "$HOME/.config/kitty" ] && mv "$HOME/.config/kitty" "$HOME/.config/kitty.bak" ;;
    *) echo "error: unknown app '$a' (foot kitty)" >&2; exit 1 ;;
  esac
done
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
