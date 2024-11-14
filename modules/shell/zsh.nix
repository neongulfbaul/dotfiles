# ZSH Home Manager Module
{ config, lib, pkgs, ... }:

{
  home.file.".config/zsh/".source = ../../config/zsh;
  home.file.".config/zsh/".recursive = true;

  programs.zsh = {
    enable = true;
    autocd = false;
    dotDir = ".config/zsh";
    enableCompletion = true;
    completionInit = ''
      source $ZDOTDIR/config.zsh
    '';
   };  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  #xdg.configFile."zsh/.zshenv".source = ./zshenv;
  #xdg.configFile."zsh/.zshrc".source = ./zshrc;
  #home.file.".config/zsh/scripts".source = ./files/scripts;
  #home.file.".config/zsh/scripts".recursive = true;
}
