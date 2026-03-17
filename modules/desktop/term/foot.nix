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
      fonts.fontconfig.enable = true; # <--- THIS IS THE MAGIC SWITCH
      programs.foot = {
        enable = true;
        settings = {
          main = {
            term  = "foot";
            shell = "${pkgs.tmux}/bin/tmux new-session -A -D -s main 'zsh -l'";
            font  = "Lilex Nerd Font:style=Regular:size=14, Noto Sans CJK JP:size=14";
          };
                    colors-dark = {
                        alpha      = "0.9";
                        background = "1e1e2e";
                        foreground = "cdd6f4";
                        regular0   = "45475a"; # black
                        regular1   = "f38ba8"; # red
                        regular2   = "a6e3a1"; # green
                        regular3   = "f9e2af"; # yellow
                        regular4   = "89b4fa"; # blue
                        regular5   = "f5c2e7"; # magenta/pink
                        regular6   = "94e2d5"; # cyan/teal
                        regular7   = "bac2de"; # white
                        bright0    = "585b70"; # bright black
                        bright1    = "f38ba8"; # bright red
                        bright2    = "a6e3a1"; # bright green
                        bright3    = "f9e2af"; # bright yellow
                        bright4    = "89b4fa"; # bright blue
                        bright5    = "f5c2e7"; # bright magenta
                        bright6    = "94e2d5"; # bright cyan
                        bright7    = "a6adc8"; # bright white
                    };
        };
      };
    };
  };
}
