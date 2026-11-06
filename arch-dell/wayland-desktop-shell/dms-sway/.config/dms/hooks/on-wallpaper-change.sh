#!/usr/bin/env sh

WALLPAPER=$(dms ipc call wallpaper get 2>/dev/null)

if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
    rizzoo -i "$WALLPAPER" -r -o
fi
