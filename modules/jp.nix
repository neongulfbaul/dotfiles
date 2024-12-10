{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    maim       # Screenshot tool
    xclip      # Clipboard management
    tesseract  # OCR tool
  ];

}   
