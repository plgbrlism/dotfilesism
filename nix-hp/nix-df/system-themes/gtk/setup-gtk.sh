#!/usr/bin/env bash
set -euo pipefail

GTK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$HOME/.themes"

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' not found. Install it first." >&2; exit 1; }
}

need git

# name|subdir|repo-path|reload-script|flatpak-prefix
THEMES="mac-tahoe|mac-tahoe/MacTahoe-gtk-theme|vinceliuice/MacTahoe-gtk-theme.git|mac-tahoe/reload.sh|Mac"

ensure_clone() {
  local dir="$1" repo="$2"
  if [ -x "$dir/install.sh" ]; then
    git -C "$dir" pull --ff-only 2>/dev/null || echo "Note: could not update $(basename "$dir"), using local copy."
    return 0
  fi
  mkdir -p "$(dirname "$dir")"
  git clone "git@github.com:$repo" "$dir" 2>/dev/null \
    || git clone "https://github.com/${repo%.git}" "$dir"
}

# the bundled gnome-theme-switcher is a python script with a /usr/bin/python3
# shebang, so it can't run on nixos; never install it. re-applied on every run
# because the source tree is a git clone that gets pulled.
patch_install() {
  local f="$1/install.sh"
  if [ -f "$f" ] && grep -q '^  install_app$' "$f"; then
    sed -i 's|^  install_app$|  # install_app skipped: NixOS-managed, bundled copy is broken on NixOS|' "$f"
    echo "Note: patched out gnome-theme-switcher auto-install."
  fi
}

install_core() {
  local entry="$1" dir repo reload
  dir="$GTK_ROOT/$(echo "$entry" | cut -d'|' -f2)"
  repo=$(echo "$entry" | cut -d'|' -f3)
  reload="$GTK_ROOT/$(echo "$entry" | cut -d'|' -f4)"

  ensure_clone "$dir" "$repo"
  patch_install "$dir"
  bash "$reload"
}

flatpak_setup() {
  local prefix="${1:-}" installed
  command -v flatpak >/dev/null 2>&1 || return 0
  if [ -n "$prefix" ]; then
    installed=$(ls -d "$THEMES_DIR"/"$prefix"* 2>/dev/null | head -n 1 | xargs basename 2>/dev/null || true)
  fi
  flatpak override --user \
    --filesystem="$HOME/.themes" \
    --filesystem="$HOME/.config/gtk-4.0" \
    ${installed:+--env=GTK_THEME=$installed} || echo "Note: flatpak override failed, continuing."
}

install_one() {
  local entry="$1"
  install_core "$entry"
  flatpak_setup "$(echo "$entry" | cut -d'|' -f5)"
}

# remove the mac variants, not the whole ~/.themes.
rm -rf "$THEMES_DIR"/Mac*

install_one "$THEMES"
echo "Done: Mac-Tahoe by vinceliuice is now installed."
