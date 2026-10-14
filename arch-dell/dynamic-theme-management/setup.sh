#!/usr/bin/env bash
set -euo pipefail
# stow rizzoo -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
for p in rizzoo; do
  while IFS= read -r -d "" s; do
    r="${s#"$p"/}"
    case "$r" in .git|.git/*|*.gitignore) continue;; esac
    [ -d "$s" ] && [ ! -L "$s" ] && continue
    t="$HOME/$r"
    if [ -e "$t" ] && [ ! -L "$t" ]; then mv "$t" "$t.bak"; echo "backup: $t"; fi
  done < <(find "$p" -mindepth 1 -print0)
done
stow --no-folding --ignore='\.gitignore' -R -d . -t "$HOME" rizzoo
echo done: stowed rizzoo
