{ pkgs, ... }:

{
  #  BLUETOOTH & SYSTEM DAEMONS
  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = false;

  # firmware updater service
  services.fwupd.enable = false;

  #  D-BUS & STORAGE AUTOMOUNTING
  services.dbus.enable = true;
  services.udisks2.enable = false;
  services.gvfs.enable = false; # toggling ~/trash or mnt
  # user-space polkit authentication agent
  security.polkit.enable = true;

  # secure shell
  services.openssh.enable = true;
}
