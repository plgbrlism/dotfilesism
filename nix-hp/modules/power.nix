{ pkgs, ... }:

{
  #  POWER MANAGEMENT
  # Automatic power tuning via Powertop system service
  powerManagement.enable = true;

  #  BATTERY MONITORING
  services.upower.enable = true;
  environment.systemPackages = [ pkgs.upower ];
  
  #  MEMORY & SWAP COMPRESSION
  # helps to maintain system responsiveness on 4GB RAM
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };
}
