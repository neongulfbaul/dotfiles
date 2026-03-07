{ config, pkgs, lib, ... }:

{
  options.modules.desktop.term.foot = {
    enable = lib.mkEnableOption "foot configuration";
  };

  config = lib.mkIf config.modules.desktop.term.foot.enable {

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
};
}
