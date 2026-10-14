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
	inputs.rizzoo.packages.${pkgs.system}.default
  ] ++ (with pkgs; [
    # Terminal Multiplexers & Editors
    neovim
    micro
    tmux
    vim
    nano

    # CLI Navigation & Modern Coreutils
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

    # Downloaders & Archive Tools
    wget
    curl
    unzip
    p7zip
    man-db

    # Terminal Screen Recording & ASCII Toys
    vhs
    cmatrix
    figlet

    # Build Tools, Compilers & Runtimes
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

    # Shell Essentials (config lives in home/shell.nix)

    # Libraries & Format Parsing Headers
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
