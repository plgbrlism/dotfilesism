#!/usr/bin/env bash
set -euo pipefail
# aur: noctalia-shell
command -v yay >/dev/null || { echo "error: yay missing" >&2; exit 1; }
yay -S --needed --noconfirm noctalia-shell
