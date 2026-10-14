#!/usr/bin/env bash
set -euo pipefail
# stow rizzoo -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/rizzoo" ] && [ ! -L "$HOME/.config/rizzoo" ] && mv "$HOME/.config/rizzoo" "$HOME/.config/rizzoo.bak"
stow -R --target="$HOME" --ignore='\.gitignore' rizzoo
echo done: stowed rizzoo
