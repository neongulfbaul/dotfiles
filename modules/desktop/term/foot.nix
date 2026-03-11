# modules/desktop/term/foot.nix
{ config, pkgs, lib, ... }:
let
  user = config.user.name;
in {
  options.modules.desktop.term.foot = {
    enable = lib.mkEnableOption "foot";
  };

  config = lib.mkIf config.modules.desktop.term.foot.enable {
    home-manager.users.${user} = {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            term  = "foot";
            shell = "${pkgs.tmux}/bin/tmux new-session -A -D -s main 'zsh -l'";
            font  = "monospace:size=14";
          };
          colors = {
            alpha = 0.9;
          };
        };
      };
    };
  };
}
