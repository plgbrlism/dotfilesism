{ pkgs, inputs, ... }:

{
  #  SwayFX
  programs.sway = {
    enable = true;
	package = pkgs.swayfx.override {
      swayfx-unwrapped = inputs.swayfx.packages.${pkgs.system}.default;
    };
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraPackages = with pkgs; [
      swaybg
    ];
  };

  #  Niri
  programs.niri.enable = true;

  #  Wayfire
  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wayfire-plugins-extra
    ];
  };

  # Labwc
  programs.labwc = {
  	enable = true;
  };

  #  shared session utilities
  environment.systemPackages = [
    inputs.i3-qol.packages.${pkgs.system}.default
  ] ++ (with pkgs; [
  	grim
  	wl-clipboard
    brightnessctl
    libnotify
    xwayland-satellite #xwayland for niri
  ]);
}
