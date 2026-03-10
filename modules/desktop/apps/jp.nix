{ config, lib, pkgs, ... }:

{
  options.modules.apps.jp.enable = lib.mkEnableOption "Japanese immersion tools";

  config = lib.mkIf config.modules.apps.jp.enable {
    home.packages = with pkgs; [
      anki-bin
      
      # CJK Fonts for proper rendering
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
    ];
  };
}
