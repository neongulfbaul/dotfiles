
{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.enableDebug = false;
    systemd.enableInspect = false;
    systemd.target = "graphical-session.target";

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "clock" ];
        modules-center = [ ];
        modules-right = [ "pulseaudio" "network" ];
      };
    };

    style = ''
      * {
        font-family: "Sans";
        font-size: 12px;
      }
    '';
  };

  programs.anyrun.config.ignoreExclusiveZones = true;
}
