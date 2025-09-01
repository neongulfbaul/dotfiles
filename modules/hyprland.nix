# hyprland-config.nix
#
# Sets up a hyprland-based desktop environment.
# Usage: Import this file in your configuration.nix and enable with:
# hyprlandConfig.enable = true;
#
# TODO: Investigate bluetuith for bluetooth TUI

{ lib, config, pkgs, ... }:

with lib;
let 
  cfg = config.hyprlandConfig;
  primaryMonitor = findFirst (x: x.primary) {} cfg.monitors;
in {
  options.hyprlandConfig = with types; {
    enable = mkBoolOpt false;
    
    extraConfig = mkOpt lines "";
    
    monitors = mkOpt (listOf (submodule {
      options = {
        output = mkOpt str "";
        mode = mkOpt str "preferred";
        position = mkOpt str "auto";
        scale = mkOpt int 1;
        disable = mkOpt bool false;
        primary = mkOpt bool false;
      };
    })) [{}];

    mako.settings = mkOpt attrs {};

    hyprlock = {
      settings = mkOpt (submodule {
        options = {
          general = mkOpt attrs {};
          input-field = mkOpt attrs {};
          backgrounds = mkOpt (listOf attrs) [];
          labels = mkOpt (listOf attrs) [];
          images = mkOpt (listOf attrs) [];
          shapes = mkOpt (listOf attrs) [];
        };
      }) {};
    };

    idle = {
      time = mkOpt int 600;       # 10 min
      autodpms = mkOpt int 1200;  # 20 min
      autolock = mkOpt int 2400;  # 40 min
      autosleep = mkOpt int 0;
    };

    # User configuration
    username = mkOpt str "user";
    
    # Theme/wallpaper settings
    wallpapers = mkOpt (attrsOf (submodule {
      options = {
        path = mkOpt str "";
        mode = mkOpt str "center";
      };
    })) {};
  };

  config = mkIf cfg.enable {
    # Set Wayland environment variables
    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    # Hyprland's aquamarine requires newer MESA drivers.
    hardware.graphics = {
      package = pkgs.mesa;
      package32 = pkgs.pkgsi686Linux.mesa;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services = {
      # There's a bug in hypridle that causes hyprlock to not read input after
      # waking up from suspend (hyprwm/hyprlock#101). swayidle doesn't suffer
      # from this issue.
      swayidle = {
        enable = true;
        events = {
          before-sleep = "loginctl lock-session";
          after-resume = "echo 'resuming from sleep'";
          lock = "hyprlock";
          unlock = "echo 'unlocked'";
        } // (optionalAttrs (cfg.idle.time > 0) {
          idlehint = toString cfg.idle.time;
        });
        timeouts =
          (optionals (cfg.idle.time > 0) [{
            timeout = cfg.idle.time;
            command = "echo 'idle timeout reached'";
            resume = "echo 'resuming from idle'";
          }]) ++
          (optionals (cfg.idle.autodpms > 0) [{
            timeout = cfg.idle.autodpms;
            command = "hyprctl dispatch dpms off";
            resume = "hyprctl dispatch dpms on";
          }]) ++
          (optionals (cfg.idle.autolock > 0) [{
            timeout = cfg.idle.autolock;
            command = "loginctl lock-session";
          }]) ++
          (optionals (cfg.idle.autosleep > 0) [{
            timeout = cfg.idle.autosleep;
            command = "systemctl suspend";
          }]);
      };

      # REVIEW: Get rid of this when wtype adds mouse support (atx/wtype#24).
      input-remapper.enable = true;
    };

    ## Bootloader.
    # I don't use a real login screen. Instead, I activate hyprlock immediately
    # after boot for basic authentication, with a specialized config to make the
    # boot up process smoother. This is enough to stop casual snoopers from
    # getting into my desktops.
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = toString (pkgs.writeShellScript "hyprland-wrapper" ''
          trap 'systemctl --user stop graphical-session.target; sleep 1' EXIT
          exec Hyprland >/dev/null
        '');
        user = cfg.username;
      };
    };
    environment.etc."greetd/environments".text = "Hyprland";

    environment.systemPackages = with pkgs; [
      hyprlock       # *fast* lock screen
      hyprpicker     # screen-space color picker
      hyprshade      # to apply shaders to the screen
      hyprshot       # instead of grim(shot) or maim/slurp

      ## For Hyprland
      mako           # dunst for wayland
      swaybg         # feh (as a wallpaper manager)
      xorg.xrandr    # for XWayland windows
      waybar         # status bar

      ## For CLIs
      gromit-mpx     # for drawing on the screen
      pamixer        # for volume control
      wlr-randr      # for monitors that hyprctl can't handle
      wf-recorder    # for screencasting
    ];

    systemd.user.targets.hyprland-session = {
      unitConfig = {
        Description = "Hyprland compositor session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };

    # Create Hyprland configuration files
    environment.etc = {
      "hypr/hyprland.conf".text = ''
        # Hyprland configuration
        # This was automatically generated by NixOS

        # Bootstrap session
        exec-once = systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
        exec-once = hyprlock --immediate
        exec-once = systemctl --user start hyprland-session.target

        # Monitor configuration
        ${concatStringsSep "\n" (map
          (v: if v.disable
              then "monitor = ${v.output},disable"
              else "monitor = ${v.output},${v.mode},${v.position},${toString v.scale}")
          cfg.monitors)}

        $PRIMARY_MONITOR = ${primaryMonitor.output or ""}
        
        ${optionalString (primaryMonitor ? output) ''
          cursor {
            default_monitor = $PRIMARY_MONITOR
          }

          workspace=1,monitor:$PRIMARY_MONITOR,default:true,persistent:true
          workspace=2,monitor:$PRIMARY_MONITOR
          workspace=3,monitor:$PRIMARY_MONITOR
          workspace=4,monitor:$PRIMARY_MONITOR
          workspace=5,monitor:$PRIMARY_MONITOR
          workspace=6,monitor:$PRIMARY_MONITOR
          workspace=7,monitor:$PRIMARY_MONITOR
          workspace=8,monitor:$PRIMARY_MONITOR
          workspace=9,monitor:$PRIMARY_MONITOR

          # Since wayland doesn't have the concept of a primary monitor,
          # XWayland windows may start in unpredictable places without a hint.
          exec-once = xrandr --output $PRIMARY_MONITOR --primary
        ''}

        # Wallpaper setup
        ${concatStringsSep "\n"
          (mapAttrsToList
            (output: w: ''
              exec-once = swaybg -o "${output}" -i "${w.path}" -m ${w.mode} &
            '')
            cfg.wallpapers)}

        # Additional user configuration
        ${cfg.extraConfig}
      '';

      "hypr/hyprlock.conf".text =
        let toHyprlockINI = n: v: ''
              ${n} {
                ${concatStringsSep "\n"
                  (mapAttrsToList (n: v: "${n} = ${toString v}") v)}
              }
            '';
        in concatStringsSep "\n" (flatten
          (mapAttrsToList
            (n: v: if isAttrs v
                   then toHyprlockINI n v
                   else map (x: toHyprlockINI (removeSuffix "s" n) x) v)
            (recursiveUpdate
              {
                general = {
                  grace = 3;
                  hide_cursor = "false";
                  disable_loading_bar = "true";
                };
              }
              cfg.hyprlock.settings)));

      "hypr/shaders/screen-dim.glsl".text = ''
        precision highp float;
        varying vec2 v_texcoord;
        uniform sampler2D tex;
        void main() {
          gl_FragColor = texture2D(tex, v_texcoord) * 0.3;
        }
      '';

      "mako/config".text =
        let toINI = mapAttrsToList (n: v: "${n}=${toString v}");
        in ''
          # config/mako/config -*- mode: ini -*-
          # This was automatically generated by NixOS
          ${concatStringsSep "\n"
            (toINI ({ "output" = (primaryMonitor.output or ""); }
                    // (filterAttrs (_: v: ! isAttrs v) cfg.mako.settings)))}

          ${concatStringsSep "\n"
            (mapAttrsToList
              (n: v: ''
                [${n}]
                ${concatStringsSep "\n" (toINI v)}
              '')
              (filterAttrs (_: v: isAttrs v) cfg.mako.settings))}

          [mode=dnd]
          invisible=1
        '';
    };

    # Create desktop entries
    environment.etc = {
      "applications/toggle-blue-light-filter.desktop".text = ''
        [Desktop Entry]
        Name=Toggle blue light filter
        Exec=hyprshade toggle blue-light-filter
        Icon=redshift
        Type=Application
        Categories=Utility;
      '';
      
      "applications/hyprpicker-rgb.desktop".text = ''
        [Desktop Entry]
        Name=Hyprpicker: grab RGB at point
        Exec=hyprpicker -r -f rgb
        Icon=com.github.finefindus.eyedropper
        Type=Application
        Categories=Utility;Graphics;
      '';
      
      "applications/hyprpicker-hsl.desktop".text = ''
        [Desktop Entry]
        Name=Hyprpicker: grab HSL at point  
        Exec=hyprpicker -r -f hsl
        Icon=com.github.finefindus.eyedropper
        Type=Application
        Categories=Utility;Graphics;
      '';
      
      "applications/hyprpicker-hex.desktop".text = ''
        [Desktop Entry]
        Name=Hyprpicker: grab hex at point
        Exec=hyprpicker -r -f hex
        Icon=com.github.finefindus.eyedropper
        Type=Application
        Categories=Utility;Graphics;
      '';
    };
  };
}
