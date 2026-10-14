#!/usr/bin/env bash
set -euo pipefail
# stow niri sway -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/niri" ] && [ ! -L "$HOME/.config/niri" ] && mv "$HOME/.config/niri" "$HOME/.config/niri.bak"
[ -e "$HOME/.config/sway" ] && [ ! -L "$HOME/.config/sway" ] && mv "$HOME/.config/sway" "$HOME/.config/sway.bak"
stow -R --target="$HOME" --ignore='\.gitignore' niri sway
[ -d "$HOME/.local" ] || mkdir -p "$HOME/.local"
[ -e "$HOME/.local/bin/dispatch" ] && [ ! -L "$HOME/.local/bin/dispatch" ] && mv "$HOME/.local/bin/dispatch" "$HOME/.local/bin/dispatch.bak"
stow -R --target="$HOME" -d helper-script dispatcher
echo "done: stowed niri sway dispatcher"
