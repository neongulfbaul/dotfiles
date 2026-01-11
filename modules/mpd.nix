
{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.mpd = {
    enable = mkEnableOption "Enable MPD + ncmpcpp";
  };

  config = mkIf config.modules.mpd.enable {

    # MPD
    programs.mpd = {
      enable = true;
      package = pkgs.mpd;
      config = ''
        music_directory     "${pkgs.writeText "mpdMusicDir" ""}"
        playlist_directory  "${pkgs.writeText "mpdPlaylistDir" ""}"
        db_file             "${pkgs.writeText "mpdDb" ""}"
        log_file            "${pkgs.writeText "mpdLog" ""}"
        pid_file            "${pkgs.writeText "mpdPid" ""}"
        state_file          "${pkgs.writeText "mpdState" ""}"
        sticker_file        "${pkgs.writeText "mpdStickers" ""}"

        bind_to_address     "127.0.0.1"
        port                "6600"

        audio_output {
            type            "pulse"
            name            "PulseAudio"
        }

        zeroconf_enabled     "no"
        auto_update          "yes"
      '';
    };

    # ncmpcpp
    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp;
      config = ''
        mpd_host = "127.0.0.1"
        mpd_port = "6600"
        visualizer_plugin = "cava"
        update_interval = 1
        show_album_art = yes
        song_browser_sort = "artist"
        bind = yes
      '';
    };

    # Cava visualizer
    programs.cava = {
      enable = true;
      package = pkgs.cava;
    };
  };
}

