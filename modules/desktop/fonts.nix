{ config, lib, pkgs, ... }:

{
  # We use a global option to toggle desktop-grade font rendering
  options.modules.desktop.fonts.enable = lib.mkEnableOption "Advanced font rendering";

  config = lib.mkIf config.modules.desktop.fonts.enable {
    fonts.fontconfig = {
      enable = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;
      subpixel.rgba = "rgb";
    };

    # You can also move your system-wide fonts here if you want them 
    # available before you even log in to your user account.
    fonts.packages = with pkgs; [
      ubuntu-classic
      dejavu_fonts
      adwaita-icon-theme
      font-awesome
      lilex
      nerd-fonts.lilex
      noto-fonts-cjk-sans
    ];
  };
}
