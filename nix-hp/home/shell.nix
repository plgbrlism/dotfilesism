{ pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
    "$HOME/scripts"
  ];

  programs.fish = {
    enable = true;

    # fastfetch
    interactiveShellInit = ''
      set -g fish_greeting ""
      if status is-interactive
        fastfetch
      end
    '';
  };

  # starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # atuin shell history sync
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
