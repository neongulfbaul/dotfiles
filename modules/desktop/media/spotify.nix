{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.media.spotify;
in {
  options.modules.desktop.media.spotify = {
    enable = mkEnableOption "Spotify client with playerctl support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
      playerctl
    ];
  };
}
