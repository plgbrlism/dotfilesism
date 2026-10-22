
{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
  	# Desktop Shell for niri+wayland
  	inputs.noctalia.packages.${pkgs.system}.default  	
  ] ++ (with pkgs; [
    # Browsers & Communication
    firefox
    brave
    google-chrome
    vesktop # discord for linux

    #  Media Players & Visualizers
    mpv
    vlc
    cava
    lavat

    #  Screen Capture & Recording
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    peek
    
    # Image utilities
    imagemagick

    #  Office, Notes & Flashcards
    obsidian
    onlyoffice-desktopeditors
    anki-bin
    bitwarden-desktop
    anydesk # remote desktop (unfree, allowUnfree already set)

    #  Vector / Design & Mobile Tools
    inkscape
    universal-android-debloater

    #  File Management & Thumbnails
    nautilus
    tumbler
    ffmpegthumbnailer
    xarchiver
  ]);
}
