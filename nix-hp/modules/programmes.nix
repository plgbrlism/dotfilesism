{ pkgs, inputs, ... }:

{
  #  CORE PROGRAM MODULES
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # fish login shell (user shell set in hosts/hp/configuration.nix)

  #  CLI & UTILITY PACKAGES
  environment.systemPackages = [
  	# my personal color palette generator
	(inputs.rizzoo.packages.${pkgs.system}.default.overrideAttrs (old: {
	  preBuild = (old.preBuild or "") + ''
	    export CARGO_PROFILE_RELEASE_LTO=false
	    export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
	  '';
	}))

	# ai coding agent
	(inputs.opencode.packages.${pkgs.system}.default)
  ] ++ (with pkgs; [
    #  text editors and terminal multiplexer
    neovim
    micro
    vim
    nano
    zed-editor
    tmux

    # cli navigation and modern coreutils
    fzf
    jq
    bat
    ripgrep
    yazi
    dust
    psmisc
    tree
    stow
    fastfetch
    btop
    glow
    systemctl-tui
    peaclock
    gum

    usbutils

    # downloaders and archiver
    wget
    curl
    unzip
    p7zip
    man-db

    # terminal screen recording
    vhs
    cmatrix
    figlet

    # build tools, compilers and runtimes
    just
    rustup
    nodejs
    python3
    clang
    gcc
    gnumake
    pkg-config
    openssl
    meson
    scdoc

    # shell essentials (config lives in home/shell.nix)

    # libraries and format parsing headers
    nlohmann_json
    tomlplusplus
    stb
    sassc
    dart-sass
    poppler
    libical
    libqalculate
    sdbus-cpp
  ]);
}
