{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.dunst = {
    enable = mkEnableOption "enable dunst";
  };

  config = mkIf config.modules.desktop.apps.dunst.enable {

  home.file.".config/dunst/".source = ../../../config/dunst;
  home.file.".config/dunst/".recursive = true;
};
}
