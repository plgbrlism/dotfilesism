#!/usr/bin/env bash
set -euo pipefail
# stow yazi -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/yazi" ] && [ ! -L "$HOME/.config/yazi" ] && mv "$HOME/.config/yazi" "$HOME/.config/yazi.bak"
stow -R --target="$HOME" --ignore='\.gitignore' yazi
echo done: stowed yazi
