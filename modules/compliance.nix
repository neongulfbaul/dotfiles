{ lib, config, pkgs, home-manager, ... }:

let
  # Define XDG directories relative to the user's home directory
  xdgDirs = {
    binDir     = "${config.home.homeDirectory}/.local/bin";
    cacheDir   = "${config.home.homeDirectory}/.cache";
    configDir  = "${config.home.homeDirectory}/.config";
    dataDir    = "${config.home.homeDirectory}/.local/share";
    stateDir   = "${config.home.homeDirectory}/.local/state";
    fakeDir    = "${config.home.homeDirectory}/.local/user";  # For stubborn apps
  };

in {
  options.home = {
    # Specify any XDG-related directories for files to be placed in
    file       = lib.mkOption { type = lib.types.attrs; default = {}; description = "Files to place directly in $HOME"; };
    configFile = lib.mkOption { type = lib.types.attrs; default = {}; description = "Files to place in $XDG_CONFIG_HOME"; };
    dataFile   = lib.mkOption { type = lib.types.attrs; default = {}; description = "Files to place in $XDG_DATA_HOME"; };
    fakeFile   = lib.mkOption { type = lib.types.attrs; default = {}; description = "Files to place in $XDG_FAKE_HOME"; };
  };

  config = {
    # Set environment variables to enforce XDG compliance
    environment.sessionVariables = lib.mkOrder 10 {
      XDG_BIN_HOME    = xdgDirs.binDir;
      XDG_CACHE_HOME  = xdgDirs.cacheDir;
      XDG_CONFIG_HOME = xdgDirs.configDir;
      XDG_DATA_HOME   = xdgDirs.dataDir;
      XDG_STATE_HOME  = xdgDirs.stateDir;

      # Stubborn programs that don't follow XDG
      XDG_FAKE_HOME   = xdgDirs.fakeDir;
      XDG_DESKTOP_DIR = xdgDirs.fakeDir;
    };

    # Install the files into their respective directories
    home-manager.users.users = {
      home = {
        file = lib.mapAttrs' (k: v: lib.nameValuePair "${xdgDirs.fakeDir}/${k}" v) config.home.fakeFile;
      };

      xdg = {
        configFile = lib.mapAttrs' (k: v: lib.nameValuePair "${xdgDirs.configDir}/${k}" v) config.home.configFile;
        dataFile   = lib.mapAttrs' (k: v: lib.nameValuePair "${xdgDirs.dataDir}/${k}" v) config.home.dataFile;

        # Force these, since it'll be considered an abstraction leak to use
        # home-manager's API anywhere outside this module.
        cacheHome  = lib.mkForce xdgDirs.cacheDir;
        configHome = lib.mkForce xdgDirs.configDir;
        dataHome   = lib.mkForce xdgDirs.dataDir;
        stateHome  = lib.mkForce xdgDirs.stateDir;
      };

      # Necessary for home-manager to work with flakes (useful for integration)
      stateVersion = 24.11;
    };
  };
}

