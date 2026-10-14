#!/usr/bin/env bash
set -euo pipefail
# stow niri sway dispatcher -> $HOME
d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$d"
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }
for p in niri sway helper-script/dispatcher; do
  while IFS= read -r -d "" s; do
    r="${s#helper-script/dispatcher/}"; [ "$p" = "helper-script/dispatcher" ] || r="${s#"$p"/}"
    case "$r" in .git|.git/*|*.gitignore) continue;; esac
    [ -d "$s" ] && [ ! -L "$s" ] && continue
    t="$HOME/$r"
    if [ -e "$t" ] && [ ! -L "$t" ]; then mv "$t" "$t.bak"; echo "backup: $t"; fi
  done < <(find "$p" -mindepth 1 -print0)
done
stow --no-folding --ignore='\\.gitignore' -R -d . -t "$HOME" niri sway
stow --no-folding -R -d helper-script -t "$HOME" dispatcher
echo "done: stowed niri sway dispatcher"
