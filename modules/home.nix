# modules/home.nix
{ lib, config, options, inputs, ... }:
let
  inherit (lib) mkOption mkOrder mkForce mkAliasDefinitions mapAttrs' nameValuePair types mkEnableOption mkDefault mkIf mkMerge;
  
  # Helpers for defining options
  mkOpt  = type: default: mkOption { inherit type default; };
  mkOpt' = type: default: description: mkOption { inherit type default description; };

  cfg  = config.home;
  user = config.user.name;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.home = {
    # The Master Switch
    enable = mkEnableOption "Home Manager integration and custom XDG infrastructure";

    # File aliases for cleaner modules
    file       = mkOpt' types.attrs {} "Files to place directly in $HOME";
    configFile = mkOpt' types.attrs {} "Files to place in $XDG_CONFIG_HOME";
    dataFile   = mkOpt' types.attrs {} "Files to place in $XDG_DATA_HOME";
    fakeFile   = mkOpt' types.attrs {} "Files to place in $XDG_FAKE_HOME (jail for bad actors)";

    # Directory definitions
    dir       = mkOpt types.str config.user.home;
    binDir    = mkOpt types.str "${cfg.dir}/.local/bin";
    cacheDir  = mkOpt types.str "${cfg.dir}/.cache";
    configDir = mkOpt types.str "${cfg.dir}/.config";
    dataDir   = mkOpt types.str "${cfg.dir}/.local/share";
    stateDir  = mkOpt types.str "${cfg.dir}/.local/state";
    fakeDir   = mkOpt types.str "${cfg.dir}/.local/user";
  };

  # Use mkMerge to define the default separately from the conditional logic
  config = mkMerge [
    # 1. Global Default (The Opt-In Guard)
    { home.enable = mkDefault false; }

    # 2. The Actual Logic (Only runs if home.enable = true)
    (mkIf cfg.enable {
      # Set XDG vars early for the whole system
      environment.sessionVariables = mkOrder 10 {
        XDG_BIN_HOME    = cfg.binDir;
        XDG_CACHE_HOME  = cfg.cacheDir;
        XDG_CONFIG_HOME = cfg.configDir;
        XDG_DATA_HOME   = cfg.dataDir;
        XDG_STATE_HOME  = cfg.stateDir;
        XDG_FAKE_HOME   = cfg.fakeDir;
      };

      # Map fakeFile entries into the jail dir
      home.file = mapAttrs' (k: v: nameValuePair "${cfg.fakeDir}/${k}" v) cfg.fakeFile;

      home-manager = {
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };

        users.${user} = {
          home.stateVersion = config.system.stateVersion;
          home.file = mkAliasDefinitions options.home.file;
          
          xdg = {
            configFile = mkAliasDefinitions options.home.configFile;
            dataFile   = mkAliasDefinitions options.home.dataFile;
            # Force HM to use our defined system paths
            cacheHome  = mkForce cfg.cacheDir;
            configHome = mkForce cfg.configDir;
            dataHome   = mkForce cfg.dataDir;
            stateHome  = mkForce cfg.stateDir;
          };
        };
      };
    })
  ];
}
