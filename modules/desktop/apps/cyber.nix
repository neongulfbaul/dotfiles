{ config, lib, pkgs, ... }:

{
  options.modules.desktop.apps.cyber.enable = lib.mkEnableOption "Cybersecurity analyst tools";

  config = lib.mkIf config.modules.desktop.apps.cyber.enable {
    home.packages = with pkgs; [
      (burpsuite.override { proEdition = true; })
    ];
  };
}
