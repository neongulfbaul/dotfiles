{ config, lib, pkgs, ... }:

let
  zshEarly = lib.mkOrder 500 ''
    # Load your static bootstrap config
    source $ZDOTDIR/config.zsh
  '';

  zshGeneral = lib.mkOrder 1000 ''
    source $ZDOTDIR/aliases.zsh
    source $ZDOTDIR/keybinds.zsh
    # Source the P10K config if it exists
    [[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
  '';

  zshCompletion = lib.mkOrder 1500 ''
    # Use the XDG Cache for completion dump to prevent .config clutter
    ZCOMPCACHE="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
    if autoload -Uz compinit; then
      compinit -u -C -d "$ZCOMPCACHE"
    fi
  '';
in
{
  # Recursively link your config directory
  home.file.".config/zsh/".source = ../config/zsh;
  home.file.".config/zsh/".recursive = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = false; # We handle this manually in zshCompletion to control timing

    history = {
      # Lissner-style State separation
      path = "${config.home.homeDirectory}/.local/state/zsh/history";
      size = 100000;
      save = 100000;
      extended = true;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    envExtra = ''
      # Security umask from Lissner's setup
      if (( EUID != 0 )); then umask 027; else umask 077; fi
      
      # Ensure Zgenom knows where to live
      export ZGEN_DIR="$XDG_DATA_HOME/zgenom"
    '';

    # The gathering point
    initContent = lib.mkMerge [ zshEarly zshGeneral zshCompletion ];
  };

  # Ensure the state directory exists to prevent history write errors
  systemd.user.tmpfiles.rules = [
    "d %h/.local/state/zsh 700 - - - -"
    "d %h/.cache/zsh 750 - - - -"
  ];
}
