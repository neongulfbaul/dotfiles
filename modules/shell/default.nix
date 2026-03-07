{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.core;
in {
  # --- 1. THE IMPORTS ---
  # This tells Nix to look at these files too. 
  # You can now remove the tmux import from your Atlas host file.
  imports = [
    ./zsh.nix
    ./tmux.nix
  ];

  # --- 2. THE OPTIONS ---
  options.modules.shell.core = {
    enable = lib.mkEnableOption "Core Shell Utilities";
  };

  # --- 3. THE CONFIG ---
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      htop
      btop
      neofetch
      ripgrep
      fd
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
