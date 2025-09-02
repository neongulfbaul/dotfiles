{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    sourceFirst = true;
    xwayland.enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    # load your own config
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;

    # leave these empty unless you need custom packages/plugins
    finalPackage = null;
    finalPortalPackage = null;
    importantPrefixes = [ ];
    plugins = [ ];
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    settings = { };
    systemd.extraCommands = [ ];
    systemd.variables = { };
  };

  programs.hyprlock = {
    enable = true;
    settings = { };
  };

  services.hypridle = {
    enable = true;
    settings = { };
  };

  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  services.hyprsunset.enable = false;
  services.hyprpolkitagent.enable = true;
}
