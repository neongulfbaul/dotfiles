# modules/desktop/apps/rofi.nix
{ config, lib, pkgs, ... }:
let
  user = config.user.name;
in {
  options.modules.desktop.apps.rofi = {
    enable = lib.mkEnableOption "rofi";
  };

  config = lib.mkIf config.modules.desktop.apps.rofi.enable {
    home-manager.users.${user} = {
      programs.rofi = {
        enable    = true;
        package   = pkgs.rofi-wayland;
        plugins   = with pkgs; [
          rofi-calc
          rofi-emoji
          rofi-games
        ];
        extraConfig = {
          modi        = "drun,run,calc,emoji,games";
          show-icons  = true;
          icon-theme  = "Papirus-Dark";
          font        = "JetBrains Mono 12";
        };
      };
    };
  };
}
