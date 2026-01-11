
{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.mpdModule = {
    enable = mkEnableOption "Enable MPD + ncmpcpp";
  };

  config = mkIf config.modules.mpdModule.enable {

    # Enable MPD service
    services.mpd.enable = true;
    services.mpd.musicDirectory = "${config.home.homeDirectory}/Music";
    services.mpd.dbFile = "${config.home.homeDirectory}/.config/mpd/tag_cache";
    services.mpd.playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    services.mpd.extraConfig = ''
      log_file "${config.home.homeDirectory}/.config/mpd/mpd.log"
      pid_file "${config.home.homeDirectory}/.config/mpd/mpd.pid"
      state_file "${config.home.homeDirectory}/.config/mpd/mpdstate"
      sticker_file "${config.home.homeDirectory}/.config/mpd/sticker.sql"
      audio_output {
          type "pulse"
          name "PulseAudio"
      }
    '';

    # Enable ncmpcpp client
    programs.ncmpcpp.enable = true;
    programs.ncmpcpp.mpdMusicDir = services.mpd.musicDirectory;

    # optional: install cava if you want visualizer in ncmpcpp
    home.packages = [ pkgs.cava ];
  };
}
