{ config, pkgs, ... }:

let 
    configDir = ../../config;
in {
    home.file = {
      # Write it recursively so other modules can write files to it
      "zsh" = { source = "${configDir}/zsh"; recursive = true; };
      };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = ".config/zsh"
      promptInit = "";
      histFile = "$XDG_STATE_HOME/zsh/history";
      enableLsColors = false;
  };
}

