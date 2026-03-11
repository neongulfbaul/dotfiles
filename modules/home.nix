# modules/home.nix
# Wires home-manager as a NixOS module and provides clean aliases:
#
#   home.file        →  home-manager.users.<name>.home.file
#   home.configFile  →  home-manager.users.<name>.xdg.configFile
#   home.dataFile    →  home-manager.users.<name>.xdg.dataFile
#   home.fakeFile    →  placed into XDG_FAKE_HOME (jail for bad actors)
#
{ lib, config, options, inputs, pkgs, ... }:
let
  inherit (lib) mkOption mkOrder mkForce mkAliasDefinitions mapAttrs' nameValuePair types;

  # Inline mkOpt helpers (or import from lib/)
  mkOpt  = type: default: mkOption { inherit type default; };
  mkOpt' = type: default: description: mkOption { inherit type default description; };

  cfg  = config.home;
  user = config.user.name;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.home = {
    # Files
    file       = mkOpt' types.attrs {} "Files to place directly in $HOME";
    configFile = mkOpt' types.attrs {} "Files to place in $XDG_CONFIG_HOME";
    dataFile   = mkOpt' types.attrs {} "Files to place in $XDG_DATA_HOME";
    fakeFile   = mkOpt' types.attrs {} "Files to place in $XDG_FAKE_HOME (non-XDG-compliant apps)";

    # Dirs
    dir       = mkOpt types.str config.user.home;
    binDir    = mkOpt types.str "${cfg.dir}/.local/bin";
    cacheDir  = mkOpt types.str "${cfg.dir}/.cache";
    configDir = mkOpt types.str "${cfg.dir}/.config";
    dataDir   = mkOpt types.str "${cfg.dir}/.local/share";
    stateDir  = mkOpt types.str "${cfg.dir}/.local/state";
    fakeDir   = mkOpt types.str "${cfg.dir}/.local/user";
  };

  config = {
    environment.localBinInPath = true;

    # Set XDG vars early to avoid load-order race conditions
    environment.sessionVariables = mkOrder 10 {
      XDG_BIN_HOME    = cfg.binDir;
      XDG_CACHE_HOME  = cfg.cacheDir;
      XDG_CONFIG_HOME = cfg.configDir;
      XDG_DATA_HOME   = cfg.dataDir;
      XDG_STATE_HOME  = cfg.stateDir;
      XDG_FAKE_HOME   = cfg.fakeDir;
      XDG_DESKTOP_DIR = cfg.fakeDir;  # keeps Desktop off $HOME
    };

    # fakeFile entries go into the jail dir
    home.file =
      mapAttrs' (k: v: nameValuePair "${cfg.fakeDir}/${k}" v)
        cfg.fakeFile;

    home-manager = {
      useUserPackages = true;
      # Pass your flake inputs through so modules can use pkgs etc.
      extraSpecialArgs = { inherit inputs; };

      users.${user} = {
        home = {
          file         = mkAliasDefinitions options.home.file;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile   = mkAliasDefinitions options.home.dataFile;
          cacheHome  = mkForce cfg.cacheDir;
          configHome = mkForce cfg.configDir;
          dataHome   = mkForce cfg.dataDir;
          stateHome  = mkForce cfg.stateDir;
        };
      };
    };
  };
}
