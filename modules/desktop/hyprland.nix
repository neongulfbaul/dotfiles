# modules/desktop/hyprland.nix
{ config, pkgs, lib, ... }:
let
  user = config.user.name;
in {
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.modules.desktop.hyprland.enable {

    # ── System level ──────────────────────────────────────────────
    programs.hyprland = {
      enable  = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL               = "1";
      MOZ_ENABLE_WAYLAND           = "1";
    };

    # ── Home-manager level ────────────────────────────────────────
    home-manager.users.${user} = {
      wayland.windowManager.hyprland = {
        enable      = true;
        package     = pkgs.hyprland;
        xwayland.enable = true;
        extraConfig = builtins.readFile ../../config/hypr/hyprland.conf;
        settings    = {};
      };

      services.hyprpaper = {
        enable = true;
        package = pkgs.hyprpaper;
        settings = {
          wallpaper = [ 
            {
                monitor = "DP-3";
                path = "${config.user.home}/.dotfiles/wallpaper/puffy-stars.jpg"; 
            }
          ];
        };
      };

      services.hypridle = {
        enable = true;
        settings.general.lock_cmd = "hyprlock";
        settings.listener = [
          {
            timeout    = 300;
            on-timeout = "hyprlock";
          }
        ];
      };

      programs.hyprlock.enable = true;

      home.packages = with pkgs; [
        hyprlock
        hyprpicker
        hyprshade
        hyprshot
        grim
        slurp
        wl-clipboard
        swappy
        mako
        xrandr
        gromit-mpx
        pamixer
        wlr-randr
      ];
    };
  };
}
