{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "foot";
        shell = "${pkgs.tmux}/bin/tmux new-session -A -D -s main 'zsh -l'";
        font = "monospace:size=14";
      };    
        colors = {
          alpha = 0.9;
        };
    };
  };
}
