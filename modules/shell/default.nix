{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.core;
in {
  # 1. Define the "Switch"
  options.modules.shell.core = {
    enable = lib.mkEnableOption "Core Shell Utilities";
  };

  # 2. Define what happens when the switch is ON
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      htop
      btop     # A "prettier" htop for testing
      neofetch # To verify the "look" of your new setup
      ripgrep
      fd
    ];

    # You can even set environment variables here
    environment.variables.EDITOR = "nvim";
  };
}
