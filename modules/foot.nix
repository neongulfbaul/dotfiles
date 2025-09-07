{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "foot";
        shell = "${pkgs.tmux}/bin/tmux new-session -A -D -s main 'zsh -l'";
      };

      # Window opacity (0.0 = fully transparent, 1.0 = fully opaque)
      # foot calls it alpha, not opacity
      window = {
        alpha = 0.7;
      };
    };
  };
}
