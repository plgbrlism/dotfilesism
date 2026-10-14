#!/usr/bin/env bash
set -euo pipefail
# stow foot kitty -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/foot" ] && [ ! -L "$HOME/.config/foot" ] && mv "$HOME/.config/foot" "$HOME/.config/foot.bak"
[ -e "$HOME/.config/kitty" ] && [ ! -L "$HOME/.config/kitty" ] && mv "$HOME/.config/kitty" "$HOME/.config/kitty.bak"
stow -R --target="$HOME" --ignore='\.gitignore' foot kitty
echo done: stowed foot kitty
