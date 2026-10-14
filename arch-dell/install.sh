#!/usr/bin/env bash
# arch-dell installer: fzf app picker, then each module's install.sh (pacman) + setup.sh (stow).
# usage: ./install.sh [--list] [--dry-run] [--yes] [--interactive] [module/app ...]
# no args on a tty = picker. bare module name = whole module. piped = everything.
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

# every installable unit. bare module = whole-module entry (no per-app split).
entries=(
  dynamic-theme-management/rizzoo
  file-management/yazi
  integrated-development-env/nvim
  integrated-development-env/zed
  monitor-management/kanshi
  shell-cli/fish
  shell-cli/zsh
  shell-prompt/starship
  shell-startup
  system-monitor/btop
  system-monitor/fastfetch
  system-themes
  terminal-emulator/foot
  terminal-emulator/kitty
  text-editor/micro
  wayland-desktop-shell/noctalia
  window-managers/niri
  window-managers/sway
  xdg-desktop-portal-management/xdg-desktop-portal
)

tty=0
[ -t 0 ] && tty=1

dry=0
yes=0
force_pick=0
given=()
for a in "$@"; do
  case "$a" in
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    --list) printf '%s\n' "${entries[@]}"; exit 0 ;;
    --dry-run) dry=1 ;;
    --yes) yes=1 ;;
    --interactive) force_pick=1 ;;
    *) given+=("$a") ;;
  esac
done

command -v pacman >/dev/null || { echo "error: arch/pacman required" >&2; exit 1; }
command -v stow >/dev/null || { echo "error: stow missing" >&2; exit 1; }

if [ "$tty" = 1 ]; then
  for dep in gum fzf; do
    command -v "$dep" >/dev/null || sudo pacman -S --needed --noconfirm "$dep"
  done
fi

picks=()
if [ "${#given[@]}" -gt 0 ] && [ "$force_pick" = 0 ]; then
  picks=("${given[@]}")
elif [ "$tty" = 1 ] || [ "$force_pick" = 1 ]; then
  [ "$tty" = 1 ] || { echo "error: picker needs a tty, pass entries (see --list)" >&2; exit 1; }
  while true; do
    mapfile -t picks < <(printf '%s\n' "${entries[@]}" \
      | fzf --multi --bind 'load:select-all,ctrl-a:select-all,ctrl-d:deselect-all' \
            --header 'tab toggles, ctrl-a all, ctrl-d none, enter confirms' \
            --preview 'e={}; m="${e%%/*}"; grep -h -E "^# (pkgs|aur|no packages|stow|usage)" "'"$root"'"/$m/install.sh "'"$root"'"/$m/setup.sh 2>/dev/null' \
            --preview-window 'right,40%' || true)
    [ "${#picks[@]}" -eq 0 ] && { echo "aborted: nothing picked"; exit 0; }
    [ "$yes" = 1 ] && break
    gum confirm "install ${#picks[@]} units: ${picks[*]}?" && break
    picks=()
    gum confirm "pick again?" || { echo "aborted"; exit 0; }
  done
else
  picks=("${entries[@]}")
fi

# validate picks
for p in "${picks[@]}"; do
  ok=0
  for e in "${entries[@]}"; do [ "$p" = "$e" ] && ok=1; done
  # bare module name also allowed (means whole module)
  for m in "${mods[@]}"; do [ "$p" = "$m" ] && ok=1; done
  [ "$ok" = 1 ] || { echo "error: unknown entry '$p' (see --list)" >&2; exit 1; }
done

# yay needed only when aur-backed units picked (rizzoo, noctalia-shell, swayfx)
need_yay=0
for p in "${picks[@]}"; do
  case "$p" in
    dynamic-theme-management*|wayland-desktop-shell*|window-managers/sway|window-managers) need_yay=1 ;;
  esac
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

# run per module in fixed order; app entries grouped, bare entries run argless
for m in "${mods[@]}"; do
  bare=0
  mapps=()
  for p in "${picks[@]}"; do
    if [ "$p" = "$m" ]; then bare=1; fi
    if [[ "$p" == "$m/"* ]]; then mapps+=("${p#"$m"/}"); fi
  done
  [ "$bare" = 0 ] && [ "${#mapps[@]}" -eq 0 ] && continue
  if [ "$tty" = 1 ]; then gum style --bold "== $m"; else echo "== $m"; fi
  if [ "$bare" = 1 ]; then
    [ "$dry" = 1 ] && { echo "would run: $m/install.sh + $m/setup.sh (all)"; continue; }
    [ -f "$m/install.sh" ] && bash "$m/install.sh"
    [ -f "$m/setup.sh" ] && bash "$m/setup.sh"
  else
    [ "$dry" = 1 ] && { echo "would run: $m/install.sh ${mapps[*]} + $m/setup.sh ${mapps[*]}"; continue; }
    [ -f "$m/install.sh" ] && bash "$m/install.sh" "${mapps[@]}"
    [ -f "$m/setup.sh" ] && bash "$m/setup.sh" "${mapps[@]}"
  fi
done

# login shell follows shell pick (arch only)
shells=()
for p in "${picks[@]}"; do
  [[ "$p" == "shell-cli/"* ]] && shells+=("${p#shell-cli/}")
done
if [ "${#shells[@]}" -gt 0 ] && [ "$dry" = 0 ]; then
  target=""
  if [ "${#shells[@]}" -eq 1 ]; then
    target="${shells[0]}"
    if [ "$tty" = 1 ] && [ "$yes" = 0 ]; then
      gum confirm "set $target as login shell?" || target=""
    fi
  elif [ "$tty" = 1 ]; then
    target=$(gum choose --header "login shell?" fish zsh "skip") || target="skip"
    [ "$target" = "skip" ] && target=""
  fi
  if [ -n "$target" ]; then
    chsh -s "$(command -v "$target")"
    echo "login shell: $target"
  fi
fi

if [ "$dry" = 1 ]; then
  echo "done (dry-run): ${picks[*]}"
  exit 0
fi

echo "done: ${picks[*]}"

# regen rizzoo outputs (untracked by design) after everything is stowed
if command -v rizzoo >/dev/null 2>&1; then
  echo "regen: rizzoo -r -o"
  rizzoo -r -o || echo "note: rizzoo regen failed, run rizzoo -r -o by hand"
else
  echo "note: rizzoo missing, generated theme files skipped"
fi

gtk=0
for p in "${picks[@]}"; do [[ "$p" == "system-themes"* ]] && gtk=1; done
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
