{ config, pkgs, ... }: {
  xdg = {
    enable = true;
    # creates the standard Downloads, Documents, etc.
    userDirs = {
      enable = true;
      createDirectories = true;
      # lowercase Mapping
      download  = "${config.home.homeDirectory}/download";
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
    # The Big Three
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Cleaning up common offenders
        #    GOPATH = "$XDG_DATA_HOME/go";
        #    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
        #    CARGO_HOME = "$XDG_DATA_HOME/cargo";
        #    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        #    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
        #    ANVIL_HOME = "$XDG_DATA_HOME/anvil"; # Since you're a Cyber Analyst
  };
}
