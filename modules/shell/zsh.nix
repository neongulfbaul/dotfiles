# modules/shell/zsh.nix
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOrder mkMerge types;
  cfg  = config.modules.shell.zsh;
  user = config.user.name;

  zshInteractive = mkOrder 1100 ''
    source $ZDOTDIR/config.zsh
    source $ZDOTDIR/aliases.zsh
    source $ZDOTDIR/keybinds.zsh
  '';
  zshCompletion = mkOrder 1500 ''
    [[ ! -f $ZDOTDIR/completion.zsh ]] || source $ZDOTDIR/completion.zsh
    [[ ! -f $ZDOTDIR/p10k.zsh ]]      || source $ZDOTDIR/p10k.zsh
  '';
in {
  options.modules.shell.zsh = {
    enable  = mkEnableOption "zsh";
    rcInit  = lib.mkOption { type = types.lines; default = ""; };
    envInit = lib.mkOption { type = types.lines; default = ""; };
  };

  config = mkIf cfg.enable {

    # ── System level ──────────────────────────────────────────────
    programs.zsh.enable = true;

    environment.sessionVariables = {
      ZDOTDIR    = "${config.home.configDir}/zsh";
      ZGEN_DIR   = "${config.home.dataDir}/zgenom";
      _FASD_DATA = "${config.home.cacheDir}/fasd";
    };

    # ── Files (via home.nix aliases) ──────────────────────────────
    # Link individual files so dotDir can coexist without conflict
    home.configFile = {
      "zsh/config.zsh".source     = ../../config/zsh/config.zsh;
      "zsh/aliases.zsh".source    = ../../config/zsh/aliases.zsh;
      "zsh/keybinds.zsh".source   = ../../config/zsh/keybinds.zsh;
      "zsh/completion.zsh".source = ../../config/zsh/completion.zsh;
      "zsh/p10k.zsh".source       = ../../config/zsh/p10k.zsh;
    };

    # ── Home-manager program config ────────────────────────────────
    home-manager.users.${user} = { lib, ... }: {
      programs.zsh = {
        enable           = true;
        dotDir           = ".config/zsh";
        enableCompletion = false;
        history = {
          path        = "${config.home.stateDir}/zsh/history";
          size        = 100000;
          save        = 100000;
          extended    = true;
          share       = true;
          ignoreDups  = true;
          ignoreSpace = true;
        };
        initContent = mkMerge [ zshInteractive zshCompletion ];
      };

      systemd.user.tmpfiles.rules = [
        "d %h/.local/state/zsh 700 - - - -"
        "d %h/.cache/zsh       750 - - - -"
      ];

      home.activation.cleanupZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -fv  "${config.home.dataDir}/zgenom/init.zsh"
        rm -fv  "${config.home.configDir}/zsh/*.zwc"
        rm -fv  "${config.home.cacheDir}/zsh/zcompdump*"
      '';
    };
  };
}
