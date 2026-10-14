#!/usr/bin/env bash
set -euo pipefail
# stow btop fastfetch -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/btop" ] && [ ! -L "$HOME/.config/btop" ] && mv "$HOME/.config/btop" "$HOME/.config/btop.bak"
[ -e "$HOME/.config/fastfetch" ] && [ ! -L "$HOME/.config/fastfetch" ] && mv "$HOME/.config/fastfetch" "$HOME/.config/fastfetch.bak"
stow -R --target="$HOME" --ignore='\.gitignore' btop fastfetch
echo done: stowed btop fastfetch
