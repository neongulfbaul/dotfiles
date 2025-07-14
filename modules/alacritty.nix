{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-D"
          "-s"
          "main"
          "sh" "-c" "zsh -l"
        ];
      };

      window = {
         opacity = 0.7;
      };     

      colors = {
        primary = {
          background = "0x000000";
          foreground = "0xcdd6f4";
        };

        normal = {
          black   = "0x45475a";
          red     = "0xf38ba8";
          green   = "0xa6e3a1";
          yellow  = "0xf9e2af";
          blue    = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan    = "0x94e2d5";
          white   = "0xbac2de";
        };

        bright = {
          black   = "0x585b70";
          red     = "0xf38ba8";
          green   = "0xa6e3a1";
          yellow  = "0xf9e2af";
          blue    = "0x89b4fa";
          magenta = "0xf5c2e7";
          cyan    = "0x94e2d5";
          white   = "0xa6adc8";
        };
      };
    };
  };
}
