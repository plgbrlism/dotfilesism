#!/usr/bin/env bash
set -euo pipefail
# stow qt5 qt6 kvantum -> $HOME; gtk themes install via gtk/setup-gtk.sh
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
for p in qt/qt5 qt/qt6 qt/kvantum; do
    while IFS= read -r -d "" s; do
    r="${s#qt/}"; r="${r#*/}"
    case "$r" in .git|.git/*|*.gitignore) continue;; esac
    [ -d "$s" ] && [ ! -L "$s" ] && continue
    t="$HOME/$r"
    if [ -e "$t" ] && [ ! -L "$t" ]; then mv "$t" "$t.bak"; echo "backup: $t"; fi
  done < <(find "$p" -mindepth 1 -print0)
done
stow --no-folding --ignore='\\.gitignore' -R -d qt -t "$HOME" qt5 qt6 kvantum
echo "note: run gtk/setup-gtk.sh for gtk themes"
echo "done: stowed qt5 qt6 kvantum"
