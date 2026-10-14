#!/usr/bin/env bash
set -euo pipefail
# stow dot-profile dot-xinitrc dot-xprofile dot-zprofile -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
for p in dot-profile dot-xinitrc dot-xprofile dot-zprofile; do
  while IFS= read -r -d "" s; do
    r="${s#"$p"/}"
    case "$r" in .git|.git/*|*.gitignore) continue;; esac
    [ -d "$s" ] && [ ! -L "$s" ] && continue
    t="$HOME/$r"
    if [ -e "$t" ] && [ ! -L "$t" ]; then mv "$t" "$t.bak"; echo "backup: $t"; fi
  done < <(find "$p" -mindepth 1 -print0)
done
stow --no-folding --ignore='\.gitignore' -R -d . -t "$HOME" dot-profile dot-xinitrc dot-xprofile dot-zprofile
echo done: stowed dot-profile dot-xinitrc dot-xprofile dot-zprofile
