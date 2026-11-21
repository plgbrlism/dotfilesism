#!/usr/bin/env bash

rizzoo -i "$VESPERTINE_WALLPAPER_PATH" -ro
vespertine msg config-reload
sed -i 's|path = ".*"|path = "'"$VESPERTINE_WALLPAPER_PATH"'"|g' ~/.local/state/vespertine-sway/vespertine/settings.toml
