#!/usr/bin/env bash
set -euo pipefail
# aur: rizzoo
command -v yay >/dev/null || { echo "error: yay missing" >&2; exit 1; }
yay -S --needed --noconfirm rizzoo
