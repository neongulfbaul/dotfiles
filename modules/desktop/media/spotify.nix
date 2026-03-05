{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.apps.spotify;
in {
  options.modules.apps.spotify = {
    enable = mkEnableOption "Spotify client with playerctl support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
      playerctl
    ];
  };
}
