{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.core;
in {
  imports = [
    ./hyprland.nix
  ];

  options.modules.desktop.core = {
    enable = lib.mkEnableOption "Core desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
    ];
    
  };
}
