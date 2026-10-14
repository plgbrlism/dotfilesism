#!/usr/bin/env bash
set -euo pipefail
# stow kanshi -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/kanshi" ] && [ ! -L "$HOME/.config/kanshi" ] && mv "$HOME/.config/kanshi" "$HOME/.config/kanshi.bak"
stow -R --target="$HOME" --ignore='\.gitignore' kanshi
echo done: stowed kanshi
