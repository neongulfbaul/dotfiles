
{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.rofi = {
    enable = mkEnableOption "enable rofi";
  };

  config = mkIf config.modules.desktop.apps.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-games
      ];

      extraConfig = {
        modi = "drun,run,calc,emoji,games";
        show-icons = true;
        icon-theme = "Papirus-Dark";
        font = "JetBrains Mono 12";
      };
    };
  };
}
