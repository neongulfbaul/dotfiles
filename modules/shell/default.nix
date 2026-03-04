{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.core;
in {
  options.modules.shell.core = {
    enable = lib.mkEnableOption "Core Shell Utilities";
  };

  config = lib.mkIf cfg.enable {
    # CHANGE THIS: Use home.packages instead of environment.systemPackages
    home.packages = with pkgs; [
      htop
      btop
      neofetch
      ripgrep
      fd
    ];

    # CHANGE THIS: Use home.sessionVariables instead of environment.variables
    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
