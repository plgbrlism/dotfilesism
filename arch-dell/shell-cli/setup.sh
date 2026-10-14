#!/usr/bin/env bash
set -euo pipefail
# stow fish zsh -> $HOME
# usage: ./setup.sh [fish] [zsh] — no args = all
apps=("$@"); [ "$#" -eq 0 ] && apps=(fish zsh)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
for a in "${apps[@]}"; do
  case "$a" in
    fish) [ -e "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ] && mv "$HOME/.config/fish" "$HOME/.config/fish.bak" ;;
    zsh) [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak" ;;
    *) echo "error: unknown app '$a' (fish zsh)" >&2; exit 1 ;;
  esac
done
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
echo done: stowed "${apps[@]}"
