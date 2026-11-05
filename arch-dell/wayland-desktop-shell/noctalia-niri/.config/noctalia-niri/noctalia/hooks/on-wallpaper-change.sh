#!/usr/bin/env bash

rizzoo -i "$NOCTALIA_WALLPAPER_PATH" -ro
noctalia msg config-reload
sed -i 's|path = ".*"|path = "'"$NOCTALIA_WALLPAPER_PATH"'"|g' ~/.local/state/noctalia-sway/noctalia/settings.toml
