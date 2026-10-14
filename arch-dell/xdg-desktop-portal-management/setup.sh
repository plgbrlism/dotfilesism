#!/usr/bin/env bash
set -euo pipefail
# stow xdg-desktop-portal -> $HOME
# usage: ./setup.sh [xdg-desktop-portal] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(xdg-desktop-portal)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/xdg-desktop-portal" ] && [ ! -L "$HOME/.config/xdg-desktop-portal" ] && mv "$HOME/.config/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal.bak"
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
