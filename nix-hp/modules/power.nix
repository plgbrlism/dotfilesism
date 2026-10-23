{ pkgs, ... }:

{
  #  POWER MANAGEMENT
  # Automatic power tuning via Powertop system service
  powerManagement.powertop.enable = true;

  #  BATTERY MONITORING (for Noctalia)
  services.upower.enable = true;
  environment.systemPackages = [ pkgs.upower ];
  
  #  MEMORY & SWAP COMPRESSION
  # Helps maintain system responsiveness on 4GB RAM
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };
}
