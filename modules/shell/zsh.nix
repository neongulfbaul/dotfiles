{ config, lib, pkgs, ... }:

with lib;

let
  # Stage 1: Load Behavior & Plugins
  zshInteractive = lib.mkOrder 1100 ''
    source $ZDOTDIR/config.zsh
    source $ZDOTDIR/aliases.zsh
    source $ZDOTDIR/keybinds.zsh
  '';

  # Stage 2: Load Completions & Initialize the Engine
  zshCompletion = lib.mkOrder 1500 ''
    # Manually source your completion file now
    [[ ! -f $ZDOTDIR/completion.zsh ]] || source $ZDOTDIR/completion.zsh
    
    # Theme always comes last
    [[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
  '';
in
{
  options.modules.shell.zsh = {
    enable = lib.mkEnableOption "zsh configuration";
  };

  config = lib.mkIf config.modules.shell.zsh.enable {
  # Recursively link your config directory
  home.file.".config/zsh/".source = ../../config/zsh;
  home.file.".config/zsh/".recursive = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = false; # We handle this manually in zshCompletion to control timing

    history = {
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
    initContent = lib.mkMerge [ zshInteractive zshCompletion ];
  };

  # Ensure the state directory exists to prevent history write errors
  systemd.user.tmpfiles.rules = [
    "d %h/.local/state/zsh 700 - - - -"
    "d %h/.cache/zsh 750 - - - -"
  ];
  # This is the "Reload Fix" emulating Henrik's hook
  home.activation.cleanupZsh = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Cleaning up Zsh binary cache and stale state..."
    # 1. Nuke the Zgenom init file so it regenerates on next shell launch
    rm -fv "${config.home.homeDirectory}/.local/share/zgenom/init.zsh"
    
    # 2. Nuke all .zwc files in your ZDOTDIR to keep the folder clean
    rm -fv ${config.home.homeDirectory}/.config/zsh/*.zwc
    
    # 3. Clear the completion dump cache
    rm -fv ${config.home.homeDirectory}/.cache/zsh/zcompdump*
  '';
    };
}
