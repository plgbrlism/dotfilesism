#!/usr/bin/env sh

rizzoo -i "$NOCTALIA_WALLPAPER_PATH" -ro
noctalia-m3e msg config-reload
sed -i 's|path = ".*"|path = "'"$NOCTALIA_WALLPAPER_PATH"'"|g' ~/.local/state/noctalia-niri/noctalia/settings.toml
sed -i 's|path = ".*"|path = "'"$NOCTALIA_WALLPAPER_PATH"'"|g' ~/.local/state/noctalia-sway/noctalia/settings.toml
