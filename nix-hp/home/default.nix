{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./dotfiles.nix
  ];

  home = {
    username = "paul";
    homeDirectory = "/home/paul";
    stateVersion = "26.05";

    sessionVariables = {
      TERMINAL = "foot";
      EDITOR = "nvim";
      VISUAL = "nvim";
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    packages = with pkgs; [
      foot
      kitty

      # qt theming (qt5 kept for legacy apps)
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
    ];
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

	desktop = null;
    publicShare = null;
    templates = null;
    projects = null;
  };
}
