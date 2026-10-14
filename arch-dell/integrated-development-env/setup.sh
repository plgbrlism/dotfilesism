#!/usr/bin/env bash
set -euo pipefail
# stow nvim zed -> $HOME
# usage: ./setup.sh [nvim] [zed] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(nvim zed)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
for a in "${apps[@]}"; do
  case "$a" in
    nvim) [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak" ;;
    zed) [ -e "$HOME/.config/zed" ] && [ ! -L "$HOME/.config/zed" ] && mv "$HOME/.config/zed" "$HOME/.config/zed.bak" ;;
    *) echo "error: unknown app '$a' (nvim zed)" >&2; exit 1 ;;
  esac
done
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
