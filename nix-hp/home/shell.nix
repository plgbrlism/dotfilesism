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

    # run fastfetch on interactive shell start
    interactiveShellInit = ''
      if status is-interactive
        fastfetch
      end
    '';
  };

  # Modern Starship Prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Atuin — shell history sync
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}
