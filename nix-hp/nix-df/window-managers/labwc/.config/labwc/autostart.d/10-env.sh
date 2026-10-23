# ~~ env ~~
# announce wayland to systemd
dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP=labwc QT_QPA_PLATFORMTHEME=qt6ct XCURSOR_THEME=Twilight-cursors XCURSOR_SIZE=30
