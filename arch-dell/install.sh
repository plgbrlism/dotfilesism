#!/usr/bin/env bash
# arch-dell installer: runs each module's install.sh (pacman) then setup.sh (stow).
# usage: ./install.sh [--list] [--dry-run] [--yes] [--interactive] [module ...]
# no args on a tty = fzf picker, gum confirms. piped = all modules, no prompts.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root"

mods=(
  dynamic-theme-management
  file-management
  integrated-development-env
  monitor-management
  shell-cli
  shell-prompt
  shell-startup
  system-monitor
  system-themes
  terminal-emulator
  text-editor
  wayland-desktop-shell
  window-managers
  xdg-desktop-portal-management
)

aur_mods=(dynamic-theme-management wayland-desktop-shell window-managers)

tty=0
[ -t 0 ] && tty=1

dry=0
yes=0
force_pick=0
sel=()
for a in "$@"; do
  case "$a" in
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    --list) printf '%s\n' "${mods[@]}"; exit 0 ;;
    --dry-run) dry=1 ;;
    --yes) yes=1 ;;
    --interactive) force_pick=1 ;;
    *) sel+=("$a") ;;
  esac
done

command -v pacman >/dev/null || { echo "error: arch/pacman required" >&2; exit 1; }
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }

if [ "$tty" = 1 ]; then
  for dep in gum fzf; do
    command -v "$dep" >/dev/null || sudo pacman -S --needed --noconfirm "$dep"
  done
fi

preview() { # $1=module -> one-line pkg summary for fzf preview
  grep -h -E '^# (pkgs|aur|no packages)' "$1/install.sh" 2>/dev/null || echo "(no install.sh)"
  echo "---"
  grep -h -E '^# stow' "$1/setup.sh" 2>/dev/null || echo "(no setup.sh)"
}

if [ "${#sel[@]}" -eq 0 ] && { [ "$force_pick" = 1 ] || [ "$tty" = 1 ]; }; then
  [ "$tty" = 1 ] || { echo "error: picker needs a tty, pass module names (see --list)" >&2; exit 1; }
  while true; do
    mapfile -t sel < <(printf '%s\n' "${mods[@]}" \
      | fzf --multi --bind 'load:select-all,ctrl-a:select-all,ctrl-d:deselect-all' \
            --header 'tab toggles, ctrl-a all, ctrl-d none, enter confirms' \
            --preview 'grep -h -E "^# (pkgs|aur|no packages|stow)" "'"$root"'"/{}/install.sh "'"$root"'"/{}/setup.sh 2>/dev/null' \
            --preview-window 'right,40%' || true)
    [ "${#sel[@]}" -eq 0 ] && { echo "aborted: nothing picked"; exit 0; }
    [ "$yes" = 1 ] && break
    gum confirm "install ${#sel[@]} modules: ${sel[*]}?" && break
    sel=()
    gum confirm "pick again?" || { echo "aborted"; exit 0; }
  done
fi
[ "${#sel[@]}" -eq 0 ] && sel=("${mods[@]}")

for m in "${sel[@]}"; do
  [ -d "$m" ] || { echo "error: unknown module '$m' (see --list)" >&2; exit 1; }
done

need_yay=0
for m in "${sel[@]}"; do
  for a in "${aur_mods[@]}"; do [ "$m" = "$a" ] && need_yay=1; done
done

if [ "$need_yay" = 1 ] && ! command -v yay >/dev/null; then
  if [ "$tty" = 1 ] && [ "$yes" = 0 ]; then
    gum confirm "aur packages needed, bootstrap yay-bin?" || { echo "aborted: yay required"; exit 1; }
  fi
  echo "bootstrap: installing yay-bin..."
  sudo pacman -S --needed --noconfirm base-devel git
  rm -rf /tmp/yay-bin
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  (cd /tmp/yay-bin && makepkg -si --noconfirm)
fi

[ "$dry" = 0 ] && sudo -v

for m in "${sel[@]}"; do
  if [ "$tty" = 1 ]; then gum style --bold "== $m"; else echo "== $m"; fi
  if [ "$dry" = 1 ]; then
    echo "would run: $m/install.sh"
    echo "would run: $m/setup.sh"
    continue
  fi
  [ -f "$m/install.sh" ] && bash "$m/install.sh"
  [ -f "$m/setup.sh" ] && bash "$m/setup.sh"
done

if [ "$dry" = 1 ]; then
  echo "done (dry-run): ${sel[*]}"
  exit 0
fi

echo "done: ${sel[*]}"

# regen rizzoo outputs (untracked by design) after everything is stowed
if command -v rizzoo >/dev/null 2>&1; then
  echo "regen: rizzoo -r -o"
  rizzoo -r -o || echo "note: rizzoo regen failed, run rizzoo -r -o by hand"
else
  echo "note: rizzoo missing, generated theme files skipped"
fi

gtk=0
for m in "${sel[@]}"; do [ "$m" = "system-themes" ] && gtk=1; done
if [ "$gtk" = 1 ]; then
  run_gtk=0
  if [ "$tty" = 1 ] && [ "$yes" = 0 ]; then
    gum confirm "run system-themes/gtk/setup-gtk.sh now?" && run_gtk=1 || true
  fi
  if [ "$run_gtk" = 1 ]; then
    bash system-themes/gtk/setup-gtk.sh
  else
    echo "note: for gtk themes run system-themes/gtk/setup-gtk.sh"
  fi
fi
