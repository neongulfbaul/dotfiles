{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.jp;
in {
  options.modules.desktop.apps.jp.enable = lib.mkEnableOption "Japanese immersion tools";

  config = lib.mkIf cfg.enable {
    
    # 1. SYSTEM LEVEL (NixOS)
    # This sits directly under 'config'
    fonts.packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
    ];

    # 2. USER LEVEL (Home Manager)
    # This is a sub-section of the system config
    home-manager.users.neon = {
      home.packages = with pkgs; [
        anki-bin
      ];
    };
  };
}
