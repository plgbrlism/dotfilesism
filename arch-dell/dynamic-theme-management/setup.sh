#!/usr/bin/env bash
set -euo pipefail
# stow rizzoo -> $HOME
# usage: ./setup.sh [rizzoo] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(rizzoo)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/rizzoo" ] && [ ! -L "$HOME/.config/rizzoo" ] && mv "$HOME/.config/rizzoo" "$HOME/.config/rizzoo.bak"
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
