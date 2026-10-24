{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/hardware.nix
    ../../modules/networking.nix
    ../../modules/audio.nix
    ../../modules/desktop.nix
    ../../modules/window-managers.nix
    ../../modules/fonts.nix
    ../../modules/virtualisation.nix
    ../../modules/power.nix
    ../../modules/programmes.nix
    ../../modules/packages.nix
    ../../modules/services.nix
    ../../modules/ssh.nix

    # distributed build
    ../../modules/build.nix
  ];

  # hostname and state version
  networking.hostName = "hp";
  system.stateVersion = "26.05";

  # user configuration
  users.users.paul = {
    isNormalUser = true;
    description = "paul";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "docker" ];
    shell = pkgs.fish;
	openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAz/ipNXgjyzEyM7pbGrJRG5J//KfTJ4IK+bvILOnNrD"
    ];
  };

  # fish login shell needs registering system-wide
  programs.fish.enable = true;

  # nix package manager & flakes configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "paul" ];
    auto-optimise-store = true;
  };

  # allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # time zone & locale
  time.timeZone = "Asia/Manila";
  i18n.defaultLocale = "en_US.UTF-8";

  # xdg-desktop environment system defaults
  environment.etc."xdg/user-dirs.defaults".text = ''
    DOWNLOAD=Downloads
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';

  environment.etc."xdg/user-dirs.conf".text = ''
    enabled=false
  '';

  # xdg-desktop portals configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        "org.freedesktop.impl.portal.Camera" = "gtk";
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.FileDialog" = "gtk";
        "org.freedesktop.impl.portal.AppChooser" = "gtk";
        "org.freedesktop.impl.portal.Settings" = "gtk";
      };
    };
  };
  
}
