#!/usr/bin/env bash
set -euo pipefail
# pkgs: fish zsh fzf fd bat tldr zoxide tmux zsh-autosuggestions zsh-syntax-highlighting
sudo pacman -S --needed --noconfirm fish zsh fzf fd bat tldr zoxide tmux zsh-autosuggestions zsh-syntax-highlighting
