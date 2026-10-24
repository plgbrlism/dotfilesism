
{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
  	# desktop shell for wayland
  	inputs.noctalia.packages.${pkgs.system}.default  	
  ] ++ (with pkgs; [
    # browsers / social
    brave
    google-chrome
    vesktop # discord for linux

    #  media players
    mpv
    vlc

    #  screen capture & recording
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    peek
    
    # image utilities
    imagemagick

    # notes / flashcards / documents
    obsidian
    onlyoffice-desktopeditors
    anki-bin
    anydesk # remote desktop

	# password manager
	bitwarden-desktop
	
    #  vector designer and mobile debloater gui
    inkscape
    universal-android-debloater

    #  file management and thumbnails
    nautilus
    tumbler
    ffmpegthumbnailer
    xarchiver
  ]);
}
