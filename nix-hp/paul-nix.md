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

`nixdf/` stores symlinks into rizzoo output (`colors-foot.ini`, `kitty/colors/colors.conf`, `sway/colors/colors.conf`, `micro/colorschemes/rizzoo.micro`, `shell-prompt/starship.toml`, …) but not the generated files themselves (same as arch: gitignored). after each rebuild, relogin and run:

```sh
rizzoo
```

to produce `variants/dynamic.*`, `starship/variants/dynamic.toml`, zed theme, etc. without this, terminals/editors fall back to their non-dynamic theme includes.

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
