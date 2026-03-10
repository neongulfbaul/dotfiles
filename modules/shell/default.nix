{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.core;
in {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./utils.nix
  ];

  options.modules.shell.core = {
    enable = lib.mkEnableOption "Core Shell Utilities";
  };

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
