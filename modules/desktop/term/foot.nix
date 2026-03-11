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
            alpha      = "0.9";
            # Rose Pine Moon
            background = "232136";
            foreground = "e0def4";
            regular0   = "393552"; # black
            regular1   = "eb6f92"; # red
            regular2   = "3e8fb0"; # green
            regular3   = "f6c177"; # yellow
            regular4   = "9ccfd8"; # blue
            regular5   = "c4a7e7"; # magenta
            regular6   = "ea9a97"; # cyan
            regular7   = "e0def4"; # white
            bright0    = "6e6a86"; # bright black
            bright1    = "eb6f92"; # bright red
            bright2    = "3e8fb0"; # bright green
            bright3    = "f6c177"; # bright yellow
            bright4    = "9ccfd8"; # bright blue
            bright5    = "c4a7e7"; # bright magenta
            bright6    = "ea9a97"; # bright cyan
            bright7    = "e0def4"; # bright white
          };
        };
      };
    };
  };
}
