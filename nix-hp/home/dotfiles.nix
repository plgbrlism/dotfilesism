{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfilesism/nix-hp/nix-df";

  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    # desktop shell (own copy under nix-df)
    "noctalia".source = link "${dotfiles}/wayland-desktop-shell/noctalia/.config/noctalia";

    # window managers
    "sway".source = link "${dotfiles}/window-managers/sway/.config/sway";
    "niri".source = link "${dotfiles}/window-managers/niri/.config/niri";
    "kanshi".source = link "${dotfiles}/monitor-management/kanshi/.config/kanshi";

    # terminals
    "kitty".source = link "${dotfiles}/terminal-emulator/kitty/.config/kitty";
    "foot".source = link "${dotfiles}/terminal-emulator/foot/.config/foot";

    # shell-prompt
    "starship".source = link "${dotfiles}/shell-prompt/starship/.config/starship/";
    "starship.toml".source = link "${dotfiles}/shell-prompt/starship/.config/starship.toml";

    # editors
    "nvim".source = link "${dotfiles}/integrated-development-env/nvim/.config/nvim";
    "micro".source = link "${dotfiles}/text-editor/micro/.config/micro";

    # cli tools
    "fastfetch".source = link "${dotfiles}/system-monitor/fastfetch/.config/fastfetch";
    "rizzoo".source = link "${dotfiles}/dynamic-theme-management/rizzoo/.config/rizzoo";
    "yazi".source = link "${dotfiles}/file-management/yazi/.config/yazi";

    # services
    "xdg-desktop-portal".source = link "${dotfiles}/xdg-desktop-portal-management/xdg-desktop-portal/.config/xdg-desktop-portal";
  };

  home.file = {
    # wm helper, spawned by sway apps.conf and niri keybinds
    ".local/bin/dispatch".source = link "${dotfiles}/window-managers/helper-script/dispatcher/.local/bin/dispatch";
    ".xinitrc".source = link "${dotfiles}/shell-startup/dot-xinitrc/.xinitrc";
  };
}
