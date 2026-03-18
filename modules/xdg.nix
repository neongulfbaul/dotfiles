{ config, pkgs, lib, ... }:
let
  user = config.user.name; # [cite: 23]
  home = config.home;
  cfg  = config.modules.xdg;
in {
  options.modules.xdg = {
      enable = mkBoolOpt true;
  };
  config = mkIf cfg.enable {
    # 1. System-wide XDG Enforcement
    nix.settings.use-xdg-base-directories = true; # [cite: 43]
    environment.systemPackages = [ pkgs.xdg-user-dirs ]; # [cite: 44]

    environment.sessionVariables = {
      # Prevents creation of ~/.compose-cache [cite: 45]
      XCOMPOSECACHE = "/tmp/xcompose"; 
      # Nvidia shader cache location [cite: 45]
      __GL_SHADER_DISK_CACHE_PATH = "/tmp/nv"; 
      # Move the PulseAudio cookie to XDG config home
      PULSE_COOKIE = "$XDG_CONFIG_HOME/pulse/cookie"; # <--- ADD THIS
    };

    # 2. Stubborn Program Fixes (The hlissner List)
    environment.variables = {
      BASH_COMPLETION_USER_FILE = "$XDG_CONFIG_HOME/bash/completion"; # [cite: 47]
      ENV             = "$XDG_CONFIG_HOME/shell/shrc"; # [cite: 48]
      MYSQL_HISTFILE  = "$XDG_STATE_HOME/mysql/history"; # [cite: 49]
      PGPASSFILE      = "$XDG_CONFIG_HOME/pg/pgpass"; # [cite: 50]
      SQLITE_HISTORY  = "$XDG_STATE_HOME/sqlite/history"; # [cite: 52]
      WGETRC          = "$XDG_CONFIG_HOME/wgetrc"; # [cite: 57]
      INPUTRC         = "$XDG_CONFIG_HOME/readline/inputrc"; # [cite: 55]
      LESSHISTFILE    = "$XDG_STATE_HOME/less/history"; # [cite: 56]
      NEWSBOAT_HOME   = "$XDG_CONFIG_HOME/newsboat";
      _JAVA_OPTIONS   = "-Duser.home=$XDG_CACHE_HOME/java";
      WINEPREFIX      = "$XDG_DATA_HOME/wine";
    };

    environment.shellAliases = {
      sqlite3 = ''sqlite3 -init "$XDG_CONFIG_HOME/sqlite3/sqliterc"''; # [cite: 59]
      wget = ''wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"''; # [cite: 60]
    };

    # 3. User Directory Configuration
    home-manager.users.${user}.xdg.userDirs = {
      enable = true; # [cite: 26]
      createDirectories = true; # [cite: 28]
      
      # Real User Directories [cite: 28, 29, 30, 31, 32]
      download  = "${config.user.home}/downloads";
      documents = "${config.user.home}/documents";
      music     = "${config.user.home}/music";
      pictures  = "${config.user.home}/pictures";
      videos    = "${config.user.home}/videos";

      # Redirecting the "junk" folders to the Jail [cite: 33, 34]
      desktop     = "${home.fakeDir}";
      publicShare = "${home.fakeDir}";
      templates   = "${home.fakeDir}";
    };

    # 4. Activation Scripts (Auto-create folders and Symlink the Jail)
    system.userActivationScripts.initXDG = ''
      # Ensure critical XDG paths exist with 700 permissions [cite: 68, 69]
      for dir in "${home.configDir}" "${home.dataDir}" "${home.cacheDir}" "${home.stateDir}" "${home.binDir}"; do
        mkdir -p "$dir" -m 700
      done

      # Setup the "Fake Home" jail [cite: 70]
      mkdir -p "${home.fakeDir}" -m 755
      [ -e "${home.fakeDir}/.local" ]  || ln -sf ~/.local  "${home.fakeDir}/.local" # [cite: 71]
      [ -e "${home.fakeDir}/.config" ] || ln -sf ~/.config "${home.fakeDir}/.config" # [cite: 72]

      # Evict ~/.pki (Firefox/NSS) [cite: 73]
      rm -rf "$HOME/.pki"
      mkdir -p "$XDG_DATA_HOME/pki/nssdb"
    '';

    # 5. Service-level Fixes
    services.dbus.implementation = "broker"; # [cite: 74]
    services.displayManager.generic.environment.XAUTHORITY = "$XDG_RUNTIME_DIR/xauthority"; # [cite: 75]
    services.displayManager.generic.environment.XCOMPOSECACHE = "/tmp/xcompose"; # [cite: 77]
  };
}
