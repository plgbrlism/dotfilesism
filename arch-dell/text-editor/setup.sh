#!/usr/bin/env bash
set -euo pipefail
# stow micro -> $HOME
# usage: ./setup.sh [micro] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(micro)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/micro" ] && [ ! -L "$HOME/.config/micro" ] && mv "$HOME/.config/micro" "$HOME/.config/micro.bak"
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
