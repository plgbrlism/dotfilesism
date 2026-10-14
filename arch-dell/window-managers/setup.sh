#!/usr/bin/env bash
set -euo pipefail
# stow niri sway (+ always dispatcher) -> $HOME
# usage: ./setup.sh [niri] [sway] — no args = all. dispatcher has no app flag, always stowed.
apps=("$@"); [ "$#" -eq 0 ] && apps=(niri sway)
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"
for a in "${apps[@]}"; do
  case "$a" in
    niri) [ -e "$HOME/.config/niri" ] && [ ! -L "$HOME/.config/niri" ] && mv "$HOME/.config/niri" "$HOME/.config/niri.bak" ;;
    sway) [ -e "$HOME/.config/sway" ] && [ ! -L "$HOME/.config/sway" ] && mv "$HOME/.config/sway" "$HOME/.config/sway.bak" ;;
    *) echo "error: unknown app '$a' (niri sway)" >&2; exit 1 ;;
  esac
done
stow -R --target="$HOME" --ignore='\.gitignore' "${apps[@]}"
[ -d "$HOME/.local" ] || mkdir -p "$HOME/.local"
[ -e "$HOME/.local/bin/dispatch" ] && [ ! -L "$HOME/.local/bin/dispatch" ] && mv "$HOME/.local/bin/dispatch" "$HOME/.local/bin/dispatch.bak"
stow -R --target="$HOME" -d helper-script dispatcher
echo "done: stowed ${apps[*]} dispatcher"
