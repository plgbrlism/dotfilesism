#!/usr/bin/env bash
set -euo pipefail
# stow fish zsh -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ] && mv "$HOME/.config/fish" "$HOME/.config/fish.bak"
[ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
stow -R --target="$HOME" --ignore='\.gitignore' fish zsh
echo done: stowed fish zsh
