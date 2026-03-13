{ lib, config, pkgs, ... }:

with lib;
let 
  cfg = config.modules.shell.git;
  # Assuming your dotfiles repo has a 'config' folder in the root
  # Adjust this path if your git config files are somewhere else
  configDir = ../../../config; 
in {
  options.modules.shell.git = {
    enable = mkEnableOption "Git shell module";
  };

  config = mkIf cfg.enable {
    # 1. Packages (Replacing user.packages with home-manager's equivalent)
    home.packages = with pkgs; [
      diff-so-fancy
      gh
      git-annex
      git-open
      act
      (mkIf config.modules.shell.gnupg.enable git-crypt)
    ];

    # 2. XDG Config Files (Replacing hey.configDir)
    # This automatically links these files to ~/.config/git/...
    xdg.configFile = {
      "git/config".source     = "${configDir}/git/config";
      "git/ignore".source     = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    # 3. ZSH Aliases
    # This assumes you have a way to inject extra RC files into ZSH
    # If using standard Home Manager ZSH:
    programs.zsh.initExtra = ''
      source ${configDir}/git/aliases.zsh
    '';
  };
}
