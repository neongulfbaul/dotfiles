{ config, lib, pkgs, ... }:

{
  options.modules.shell.utils.enable = lib.mkEnableOption "General CLI utilities";

  config = lib.mkIf config.modules.shell.utils.enable {
    home.packages = with pkgs; [
      ouch             # Easy compression/decompression
      unzip
      p7zip
      tree             # Directory visualization
      tokei            # Code statistics
      dust             # Disk usage (du replacement)
      bc               # Calculator
      libnotify        # Sending alerts to Dunst
      ffmpeg           # Media manipulation
      internetarchive  # CLI for IA
    ];
  };
}
