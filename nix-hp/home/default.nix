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
    };

    packages = with pkgs; [
      foot
      kitty
    ];
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
