{ config, lib, pkgs, ... }:

{
  options.modules.apps.cyber.enable = lib.mkEnableOption "Cybersecurity analyst tools";

  config = lib.mkIf config.modules.apps.cyber.enable {
    home.packages = with pkgs; [
      (burpsuite.override { proEdition = true; })
    ];
  };
}
