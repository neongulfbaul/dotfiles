{ config, pkgs, ... }: {
  xdg = {
    enable = true;
    # creates the standard Downloads, Documents, etc.
    userDirs = {
      enable = true;
      createDirectories = true;
      # lowercase Mapping
      download  = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      music     = "${config.home.homeDirectory}/music";
      pictures  = "${config.home.homeDirectory}/pictures";
      videos    = "${config.home.homeDirectory}/videos";

      # Nullify the bloat
      desktop   = null;
      publicShare = null;
      templates = null;

      # Custom path for screenshots (handy for Cyber Analysts)
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/pictures/screenshots";
      };
    };
  };

  # The "Force" Layer: Some apps only obey XDG if these env vars are set explicitly.
  home.sessionVariables = {

    # Force lowercase for the user dirs we just made
    XDG_DOWNLOAD_DIR  = "${config.xdg.userDirs.download}";
    XDG_DOCUMENTS_DIR = "${config.xdg.userDirs.documents}";
    XDG_MUSIC_DIR     = "${config.xdg.userDirs.music}";
    XDG_PICTURES_DIR  = "${config.xdg.userDirs.pictures}";
    XDG_VIDEOS_DIR    = "${config.xdg.userDirs.videos}";
    # Cleaning up common offenders
        #    GOPATH = "$XDG_DATA_HOME/go";
        #    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
        #    CARGO_HOME = "$XDG_DATA_HOME/cargo";
        #    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        #    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
        #    ANVIL_HOME = "$XDG_DATA_HOME/anvil"; # Since you're a Cyber Analyst
  };
}
