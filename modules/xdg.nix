# modules/xdg.nix
{ config, lib, ... }:
let
  user = config.user.name;
  hm   = config.home-manager.users.${user};
in {
  config = {
    # ── System level ──────────────────────────────────────────────
    environment.sessionVariables = {
      XDG_DOWNLOAD_DIR  = "${config.user.home}/downloads";
      XDG_DOCUMENTS_DIR = "${config.user.home}/documents";
      XDG_MUSIC_DIR     = "${config.user.home}/music";
      XDG_PICTURES_DIR  = "${config.user.home}/pictures";
      XDG_VIDEOS_DIR    = "${config.user.home}/videos";
    };

    # ── Home-manager level ────────────────────────────────────────
    home-manager.users.${user} = {
      xdg = {
        enable = true;
        userDirs = {
          enable            = true;
          createDirectories = true;
          download          = "${config.user.home}/downloads";
          documents         = "${config.user.home}/documents";
          music             = "${config.user.home}/music";
          pictures          = "${config.user.home}/pictures";
          videos            = "${config.user.home}/videos";
          desktop           = "${config.home.fakeDir}";
          publicShare       = "${config.home.fakeDir}";
          templates         = "${config.home.fakeDir}";
          extraConfig = {
            XDG_SCREENSHOTS_DIR = "${config.user.home}/pictures/screenshots";
          };
        };
      };
    };
  };
}
