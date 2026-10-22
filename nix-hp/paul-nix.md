# nix-hp: nixos config for hp notebook 14-ck0115tu

## layout

```
nix-hp/
├── flake.nix          <- entry point, pins nixpkgs 26.05 + home-manager + extras
├── home/              <- user layer (shell, git, dotfile symlinks)
├── hosts/hp/          <- machine layer (imports modules, user, locale)
└── modules/           <- one file per concern, no cross-imports
```

## home/

| file | holds |
|---|---|
| `default.nix` | user paul, fish login shell, kitty/foot, session vars (`TERMINAL=kitty`, `EDITOR=nvim`) |
| `shell.nix` | hm fish (fastfetch on start), starship + atuin fish integrations |
| `git.nix` | git identity, lazygit |
| `dotfiles.nix` | out-of-store symlinks `~/dotfilesism/nix-hp/nixdf/...` → `~/.config` |

## dotfiles trick

nix-hp has its own dotfiles copy in `nixdf/` (sync manually from `arch-dell/` when the dell config changes). nix only links them:

- wm: sway, niri, kanshi (+ `.local/bin/dispatch`, spawned by both)
- terminals: kitty, foot
- editors: nvim, micro (+ yazi, fastfetch, rizzoo)
- themes: qt5ct/qt6ct/kvantum via `system-themes`, noctalia shell
- portals: `portals.conf` (wlr default, gtk dialogs)

fish itself is hm-declarative (`shell.nix`), not linked. starship prompt comes from hm module, not the repo theme.

### rizzoo-generated files

the four theme symlinks currently resolve to the static `calamus-*` variants so the config works with no theme daemon:

```
foot/colors/color-foot.ini        -> variants/calamus-umber.conf
kitty/colors/colors.conf          -> variants/calamus-dark.conf
sway/colors/colors.conf           -> variants/calamus-umber.conf
micro/colorschemes/rizzoo.micro   -> variants/calamus-umber.micro
```

`nvim/lua/rizzoo/palette.lua` and `zed/themes/dynamic.json` are committed with `git add -f` (normally gitignored generator outputs).

to switch back to rizzoo-generated dynamic colors later: run `rizzoo` once on the hp machine, then repoint:

```sh
cd ~/dotfilesism/nix-hp/nixdf
ln -sfn variants/dynamic.ini   terminal-emulator/foot/.config/foot/colors/color-foot.ini
ln -sfn variants/dynamic.conf  terminal-emulator/kitty/.config/kitty/colors/colors.conf
ln -sfn variants/dynamic.conf  window-managers/sway/.config/sway/colors/colors.conf
ln -sfn variants/dynamic.micro text-editor/micro/.config/micro/colorschemes/rizzoo.micro
```

## modules/

| module | holds |
|---|---|
| `boot.nix` | systemd-boot, kernel params |
| `hardware.nix` | intel microcode, gpu drivers |
| `networking.nix` | networkmanager + iwd, firewall |
| `audio.nix` | pipewire stack |
| `desktop.nix` | xserver xkb, ly display manager, libinput, xdg portals, gtk theme utils |
| `window-managers.nix` | swayfx, niri, xwayland-satellite (X11 apps like anydesk), brightnessctl |
| `fonts.nix` | noto, dejavu, nerd fonts |
| `virtualisation.nix` | docker, weekly prune |
| `power.nix` | powertop, zram 50% (4gb ram) |
| `programmes.nix` | neovim, micro, cli tools, toolchains, rizzoo input |
| `packages.nix` | browsers, media, office, anydesk, file management |
| `services.nix` | dbus, polkit, openssh (bluetooth/fwupd/udisks off) |
| `ssh.nix` / `build.nix` | keys, distributed build |

## workflow

```sh
cd ~/dotfilesism/nix-hp
nixos-rebuild dry-build --flake .#hp   # preview
sudo nixos-rebuild switch --flake .#hp # apply (relogin via ly after shell changes)
```
