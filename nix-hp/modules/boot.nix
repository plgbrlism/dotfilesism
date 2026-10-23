{ pkgs, ... }:

{
  #  BOOTLOADER (UEFI)
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi.canTouchEfiVariables = true;
  };

  #  KERNEL PARAMETERS
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "mem_sleep_default=s2idle"
    "acpi_sleep=nonvs"
  ];

  # stable LTS lernel for Celeron N4000
  boot.kernelPackages = pkgs.linuxPackages;
  boot.consoleLogLevel = 3;
}
