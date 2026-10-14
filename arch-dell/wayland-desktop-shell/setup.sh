#!/usr/bin/env bash
set -euo pipefail
# stow noctalia -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/noctalia" ] && [ ! -L "$HOME/.config/noctalia" ] && mv "$HOME/.config/noctalia" "$HOME/.config/noctalia.bak"
stow -R --target="$HOME" --ignore='\.gitignore' noctalia
echo done: stowed noctalia
