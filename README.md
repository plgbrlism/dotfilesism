# dotfilesism

personal minimal dotfiles. arch laptop via stow and hp box via nix flake.

## layout

- `arch-dell/` — arch configs, one dir per category. each has `install.sh` (pacman) + `setup.sh` (stow).
- `nix-hp/` — nixos flake for hp machine. separate, not touched by arch installer.

## usage

```sh
git clone <repo> ~/dotfilesism
cd ~/dotfilesism/arch-dell
./install.sh --list          # show modules
./install.sh --dry-run       # preview
./install.sh                 # fzf picker + gum confirms on a tty
./install.sh --yes            # picker, no confirms
./install.sh window-managers terminal-emulator text-editor
```

per module by hand:

```sh
cd arch-dell/window-managers
./install.sh   # packages
./setup.sh     # stow into $HOME, existing files moved to *.bak
```

gtk themes need one extra step (upstream clones, not stowed):

```sh
./arch-dell/system-themes/gtk/setup-gtk.sh
```

## categories

- `dynamic-theme-management` — rizzoo, regenerates `dynamic*` color files from wallpaper.
- `file-management` — yazi config + keymap.
- `integrated-development-env` — nvim (lazyvim + calamus) and zed settings.
- `monitor-management` — kanshi output profiles.
- `shell-cli` — fish config, zshrc (oh-my-zsh).
- `shell-prompt` — starship, rizzoo variant symlinked as default.
- `shell-startup` — .profile, .zprofile, .xprofile, .xinitrc.
- `system-monitor` — btop theme hook, fastfetch art + presets.
- `system-themes` — qt5ct/qt6ct/kvantum configs (stowed), gtk themes via setup-gtk.sh.
- `terminal-emulator` — foot and kitty, calamus + dynamic variants.
- `text-editor` — micro settings, bindings, calamus variants.
- `wayland-desktop-shell` — noctalia shell config + rizzoo palette.
- `window-managers` — niri (kdl split), sway (split conf), dispatch helper (`~/.local/bin/dispatch`).
- `xdg-desktop-portal-management` — portals.conf (wlr default, gtk dialogs).

## notes

- rizzoo-managed files (`dynamic*`, palettes, `layout.kdl`, nvim `palette.lua`) are untracked by design. installer regenerates them at the end (`rizzoo -r -o`); rerun that anytime by hand.
- `btop.conf`, shell history, keys never tracked (see `.gitignore`).
- gtk theme source (`mac-tahoe/MacTahoe-gtk-theme`) is a nested checkout, not versioned here.
- arch only. needs `stow`, `git`, `yay` (auto-bootstrapped for aur modules).
