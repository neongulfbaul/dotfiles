{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

  # read your config file from config/hypr
  extraConfig = builtins.readFile ../config/hypr/hyprland.conf;

  # you can still keep some inline settings if you want
  settings = { };
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;

  home.packages = with pkgs; [
    hyprlock       # *fast* lock screen
    hyprpicker     # screen-space color picker
    hyprshade      # to apply shaders to the screen
    hyprshot       # instead of grim(shot) or maim/slurp

    ## For Hyprland
    mako           # dunst for wayland
    swaybg         # feh (as a wallpaper manager)
    xorg.xrandr    # for XWayland windows

    ## For CLIs
    gromit-mpx     # for drawing on the screen
    pamixer        # for volume control
    wlr-randr      # for monitors that hyprctl can't handle
    ## Waiting for NixOS/nixpkgs@7249e6c56141 to reach nixos-unstable
    # wf-recorder    # for screencasting
  ];

  home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
}
