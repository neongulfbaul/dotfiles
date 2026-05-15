{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.services.sunshine;
in {
  options.modules.services.sunshine = {
    enable = lib.mkEnableOption "sunshine";
  };

  config = lib.mkIf cfg.enable {
    # Sunshine is a system service in NixOS
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # Required for Wayland/Hyprland screen capture
      openFirewall = true; # Opens 47984-48010 for local streaming
    };

    # Requirements for virtual input (controller/mouse emulation)
    hardware.uinput.enable = true;
    
    # Add your user to the necessary groups
    users.users.${config.user.name}.extraGroups = [ 
      "uinput" 
      "video" 
    ];

    # Udev rules to ensure uinput is accessible to the sunshine service
    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';
  };
}
