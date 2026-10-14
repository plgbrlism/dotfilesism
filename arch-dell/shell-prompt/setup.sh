#!/usr/bin/env bash
set -euo pipefail
# stow starship -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/starship" ] && [ ! -L "$HOME/.config/starship" ] && mv "$HOME/.config/starship" "$HOME/.config/starship.bak"
[ -e "$HOME/.config/starship.toml" ] && [ ! -L "$HOME/.config/starship.toml" ] && mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
stow -R --target="$HOME" --ignore='\.gitignore' starship
echo done: stowed starship
