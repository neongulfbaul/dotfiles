# hyprland.nix
{ config, pkgs, ... }:

{
  # Basic Hyprland setup
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Essential packages
  environment.systemPackages = with pkgs; [
    hyprlock       # lock screen
    hyprpicker     # color picker
    hyprshade      # screen shaders
    hyprshot       # screenshots
    mako           # notifications
    swaybg         # wallpapers
    waybar         # status bar
    xorg.xrandr    # for XWayland
    pamixer        # volume control
    wlr-randr      # monitor control
  ];

  # Configuration files
  environment.etc = {
    # Hyprlock config
    "hypr/hyprlock.conf".text = ''
      general {
        grace = 3
        hide_cursor = false
        disable_loading_bar = true
      }

      background {
        monitor =
        path = screenshot
        blur_passes = 2
        blur_size = 8
      }

      input-field {
        monitor =
        size = 250, 60
        outline_thickness = 2
        dots_size = 0.2
        dots_spacing = 0.2
        dots_center = true
        outer_color = rgba(0, 0, 0, 0)
        inner_color = rgba(0, 0, 0, 0.5)
        font_color = rgb(200, 200, 200)
        fade_on_empty = false
        placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
        hide_input = false
        position = 0, -120
        halign = center
        valign = center
      }

      label {
        monitor =
        text = Hi $USER
        color = rgba(200, 200, 200, 1.0)
        font_size = 25
        font_family = Inter
        position = 0, -40
        halign = center
        valign = center
      }
    '';

    # Mako notification config
    "mako/config".text = ''
      # Mako configuration
      anchor=top-right
      background-color=#2d3748
      border-color=#4a5568
      border-radius=8
      border-size=2
      font=Inter 11
      margin=10
      padding=10
      text-color=#e2e8f0
      timeout=5000
      max-visible=5
      default-timeout=5000

      [urgency=high]
      border-color=#e53e3e
      background-color=#742a2a
      timeout=0

      [mode=dnd]
      invisible=1
    '';

    # Screen dimming shader for hyprshade
    "hypr/shaders/screen-dim.glsl".text = ''
      precision highp float;
      varying vec2 v_texcoord;
      uniform sampler2D tex;
      void main() {
        gl_FragColor = texture2D(tex, v_texcoord) * 0.3;
      }
    '';
  };

    environment.etc."hypr/hyprland.conf".text = ''
    # Generated Hyprland configuration - DO NOT EDIT
    # This combines system config with your personal config
    
    # Import system-generated configs first
    source = /etc/hypr/monitors.conf
    source = /etc/hypr/system.conf
    
    # Then import your personal config
    source = ~/.dotfiles/config/hypr/hyprland.conf
  '';

  # Monitor configuration - customize these for your setup
  # You can also put this directly in your hyprland.conf if you prefer
  environment.etc."hypr/monitors.conf".text = ''
    # Monitor configuration
    # Uncomment and modify for your setup:
    
    # Single monitor example:
    # monitor = DP-1, 1920x1080@144, 0x0, 1
    
    # Dual monitor example:
    # monitor = DP-1, 1920x1080@144, 0x0, 1
    # monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
    
    # Default fallback
    monitor = , preferred, auto, 1
  '';

  # Auto-start services
  systemd.user.services = {
    # Idle management with swayidle
    swayidle = {
      description = "Swayidle idle management";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.swayidle}/bin/swayidle -w \
            timeout 600 'hyprctl dispatch dpms off' \
                resume 'hyprctl dispatch dpms on' \
            timeout 1200 'hyprlock' \
            timeout 2400 'systemctl suspend' \
            before-sleep 'hyprlock'
        '';
        Restart = "always";
      };
    };

    # Start mako notifications
    mako = {
      description = "Mako notification daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "always";
      };
    };

    # Start waybar
    waybar = {
      description = "Waybar status bar";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "always";
      };
    };
  };
}
