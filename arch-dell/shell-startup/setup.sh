#!/usr/bin/env bash
set -euo pipefail
# stow dot-profile dot-xinitrc dot-xprofile dot-zprofile -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ] && mv "$HOME/.profile" "$HOME/.profile.bak"
[ -e "$HOME/.xinitrc" ] && [ ! -L "$HOME/.xinitrc" ] && mv "$HOME/.xinitrc" "$HOME/.xinitrc.bak"
[ -e "$HOME/.xprofile" ] && [ ! -L "$HOME/.xprofile" ] && mv "$HOME/.xprofile" "$HOME/.xprofile.bak"
[ -e "$HOME/.zprofile" ] && [ ! -L "$HOME/.zprofile" ] && mv "$HOME/.zprofile" "$HOME/.zprofile.bak"
stow -R --target="$HOME" --ignore='\.gitignore' dot-profile dot-xinitrc dot-xprofile dot-zprofile
echo done: stowed dot-profile dot-xinitrc dot-xprofile dot-zprofile
