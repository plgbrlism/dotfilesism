{ pkgs, lib, ... }:

{
  #  BLUETOOTH & SYSTEM DAEMONS
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;

  # firmware updater service
  services.fwupd.enable = false;

  #  D-BUS & STORAGE AUTOMOUNTING
  services.dbus.enable = true;
  services.udisks2.enable = lib.mkForce false; # currently off, for mounting
  services.gvfs.enable = true;
  # user-space polkit authentication agent
  security.polkit.enable = true;

  # SSH
  services.openssh.enable = true;
}
