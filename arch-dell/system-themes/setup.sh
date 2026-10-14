#!/usr/bin/env bash
set -euo pipefail
# stow qt5 qt6 kvantum -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
[ -e "$HOME/.config/qt5ct" ] && [ ! -L "$HOME/.config/qt5ct" ] && mv "$HOME/.config/qt5ct" "$HOME/.config/qt5ct.bak"
[ -e "$HOME/.config/qt6ct" ] && [ ! -L "$HOME/.config/qt6ct" ] && mv "$HOME/.config/qt6ct" "$HOME/.config/qt6ct.bak"
[ -e "$HOME/.config/Kvantum" ] && [ ! -L "$HOME/.config/Kvantum" ] && mv "$HOME/.config/Kvantum" "$HOME/.config/Kvantum.bak"
stow -R --target="$HOME" --ignore='\.gitignore' -d qt qt5 qt6 kvantum
echo "note: run gtk/setup-gtk.sh for gtk themes"
echo "done: stowed qt5 qt6 kvantum"
