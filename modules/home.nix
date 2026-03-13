{ lib, config, options, inputs, ... }:
let
  inherit (lib) mkOption mkOrder mkForce mkAliasDefinitions mapAttrs' nameValuePair types; # [cite: 1]
  
  # Helpers for defining options
  mkOpt  = type: default: mkOption { inherit type default; }; # [cite: 2]
  mkOpt' = type: default: description: mkOption { inherit type default description; }; # [cite: 3]

  cfg  = config.home;
  user = config.user.name; # [cite: 4]
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager # [cite: 4]
  ];

  options.home = {
    # File aliases for cleaner modules
    file       = mkOpt' types.attrs {} "Files to place directly in $HOME"; # [cite: 5]
    configFile = mkOpt' types.attrs {} "Files to place in $XDG_CONFIG_HOME"; # [cite: 6]
    dataFile   = mkOpt' types.attrs {} "Files to place in $XDG_DATA_HOME"; # [cite: 7]
    fakeFile   = mkOpt' types.attrs {} "Files to place in $XDG_FAKE_HOME (jail for bad actors)"; # [cite: 8]

    # Directory definitions
    dir       = mkOpt types.str config.user.home; # [cite: 9]
    binDir    = mkOpt types.str "${cfg.dir}/.local/bin"; # [cite: 10]
    cacheDir  = mkOpt types.str "${cfg.dir}/.cache";
    configDir = mkOpt types.str "${cfg.dir}/.config";
    dataDir   = mkOpt types.str "${cfg.dir}/.local/share"; # [cite: 11]
    stateDir  = mkOpt types.str "${cfg.dir}/.local/state";
    fakeDir   = mkOpt types.str "${cfg.dir}/.local/user"; # [cite: 11]
  };

  config = {
    # Set XDG vars early for the whole system
    environment.sessionVariables = mkOrder 10 { # [cite: 13]
      XDG_BIN_HOME    = cfg.binDir;
      XDG_CACHE_HOME  = cfg.cacheDir; # [cite: 14]
      XDG_CONFIG_HOME = cfg.configDir;
      XDG_DATA_HOME   = cfg.dataDir;
      XDG_STATE_HOME  = cfg.stateDir;
      XDG_FAKE_HOME   = cfg.fakeDir; # [cite: 15]
    };

    # Map fakeFile entries into the jail dir
    home.file = mapAttrs' (k: v: nameValuePair "${cfg.fakeDir}/${k}" v) cfg.fakeFile; # [cite: 16]

    home-manager = {
      useUserPackages = true; # [cite: 17]
      extraSpecialArgs = { inherit inputs; }; # [cite: 18, 19]

      users.${user} = {
        home.stateVersion = config.system.stateVersion; # [cite: 20]
        home.file = mkAliasDefinitions options.home.file;

        xdg = {
          configFile = mkAliasDefinitions options.home.configFile; # [cite: 20]
          dataFile   = mkAliasDefinitions options.home.dataFile; # [cite: 21]
          # Force HM to use our defined system paths
          cacheHome  = mkForce cfg.cacheDir; # [cite: 21]
          configHome = mkForce cfg.configDir;
          dataHome   = mkForce cfg.dataDir; # [cite: 22]
          stateHome  = mkForce cfg.stateDir;
        };
      };
    };
  };
}
