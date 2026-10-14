#!/usr/bin/env bash
set -euo pipefail
# usage: ./install.sh [fish] [zsh] — no args = all
# pkgs: fzf fd bat tldr zoxide tmux + fish | zsh zsh-autosuggestions zsh-syntax-highlighting
apps=("$@"); [ "$#" -eq 0 ] && apps=(fish zsh)
# base tools, shell-agnostic
sudo pacman -S --needed --noconfirm fzf fd bat tldr zoxide tmux
for a in "${apps[@]}"; do
  case "$a" in
    fish) sudo pacman -S --needed --noconfirm fish ;;
    zsh) sudo pacman -S --needed --noconfirm zsh zsh-autosuggestions zsh-syntax-highlighting ;;
    *) echo "error: unknown app '$a' (fish zsh)" >&2; exit 1 ;;
  esac
done
