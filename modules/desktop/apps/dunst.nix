{ config, lib, pkgs, ... }:

{
  home.file.".config/dunst/".source = ../config/dunst;
  home.file.".config/dunst/".recursive = true;
}
