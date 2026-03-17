# modules/profiles/role/server.nix
{ lib, config, pkgs, ... }:
with lib;
mkIf (config.modules.profiles.role == "server") {
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  
  # Clear old logs
  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=21d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };
  
  # Security
  security.protectKernelImage = true;
  
  # Power management
  powerManagement.cpuFreqGovernor = mkDefault "ondemand";
}
