# modules/xdg.nix
{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault mkMerge;
  user = config.user.name;
  home = config.home;
  cfg = config.modules.xdg;
in {
  options.modules.xdg = {
    enable = mkEnableOption "XDG Base Directory enforcement and folder redirection";
  };

  config = mkMerge [
    # 1. Global Default (Opt-In Guard)
    { modules.xdg.enable = mkDefault false; }

    # 2. The Actual Logic
    (mkIf cfg.enable {
      # System-wide XDG Enforcement
      nix.settings.use-xdg-base-directories = true;
      environment.systemPackages = [ pkgs.xdg-user-dirs ];

      environment.sessionVariables = {
        XCOMPOSECACHE = "/tmp/xcompose"; 
        __GL_SHADER_DISK_CACHE_PATH = "/tmp/nv"; 
        PULSE_COOKIE = "$XDG_CONFIG_HOME/pulse/cookie";
      };

      # Stubborn Program Fixes
      environment.variables = {
        BASH_COMPLETION_USER_FILE = "$XDG_CONFIG_HOME/bash/completion";
        ENV             = "$XDG_CONFIG_HOME/shell/shrc";
        MYSQL_HISTFILE  = "$XDG_STATE_HOME/mysql/history";
        PGPASSFILE      = "$XDG_CONFIG_HOME/pg/pgpass";
        SQLITE_HISTORY  = "$XDG_STATE_HOME/sqlite/history";
        WGETRC          = "$XDG_CONFIG_HOME/wgetrc";
        INPUTRC         = "$XDG_CONFIG_HOME/readline/inputrc";
        LESSHISTFILE    = "$XDG_STATE_HOME/less/history";
        NEWSBOAT_HOME   = "$XDG_CONFIG_HOME/newsboat";
        _JAVA_OPTIONS   = "-Duser.home=$XDG_CACHE_HOME/java";
        WINEPREFIX      = "$XDG_DATA_HOME/wine";
      };

      environment.shellAliases = {
        sqlite3 = ''sqlite3 -init "$XDG_CONFIG_HOME/sqlite3/sqliterc"'';
        wget = ''wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'';
      };

      # User Directory Configuration
      home-manager.users.${user}.xdg.userDirs = {
        enable = true;
        createDirectories = true;
        
        download  = "${config.user.home}/downloads";
        documents = "${config.user.home}/documents";
        music     = "${config.user.home}/music";
        pictures  = "${config.user.home}/pictures";
        videos    = "${config.user.home}/videos";

        desktop     = "${home.fakeDir}";
        publicShare = "${home.fakeDir}";
        templates   = "${home.fakeDir}";
      };

      # Activation Scripts
      system.userActivationScripts.initXDG = ''
        for dir in "${home.configDir}" "${home.dataDir}" "${home.cacheDir}" "${home.stateDir}" "${home.binDir}"; do
          mkdir -p "$dir" -m 700
        done

        mkdir -p "${home.fakeDir}" -m 755
        [ -e "${home.fakeDir}/.local" ]  || ln -sf ~/.local  "${home.fakeDir}/.local"
        [ -e "${home.fakeDir}/.config" ] || ln -sf ~/.config "${home.fakeDir}/.config"

        rm -rf "$HOME/.pki"
        mkdir -p "$XDG_DATA_HOME/pki/nssdb"
      '';

      # Service-level Fixes
      services.dbus.implementation = "broker";
      services.displayManager.generic.environment.XAUTHORITY = "$XDG_RUNTIME_DIR/xauthority";
      services.displayManager.generic.environment.XCOMPOSECACHE = "/tmp/xcompose";
    })
  ];
}
