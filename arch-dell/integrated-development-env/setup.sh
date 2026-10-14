#!/usr/bin/env bash
set -euo pipefail
# stow nvim zed -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
[ -e "$HOME/.config/zed" ] && [ ! -L "$HOME/.config/zed" ] && mv "$HOME/.config/zed" "$HOME/.config/zed.bak"
stow -R --target="$HOME" --ignore='\.gitignore' nvim zed
echo done: stowed nvim zed
