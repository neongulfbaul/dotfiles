{ config, pkgs, ... }:

# jp learning tools
  environment.systemPackages = [
    pkgs.lime3ds
    pkgs.firefox-devedition
    pkgs.noto-fonts-cjk-sans
    pkgs.perl540Packages.ImageOCRTesseract
    pkgs.rtorrent
  ];


