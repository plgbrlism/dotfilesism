{ pkgs, ... }:

{
  # realtime scheduling daemon for audio threads
  security.rtkit.enable = true;

  # pipewire service configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # audio mixer gui
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
  ];
}
