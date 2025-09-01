{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.hyprland;
  primaryMonitor = head (filter (m: m.primary) cfg.monitors or []);
in {
  options.modules.hyprland = with types; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland Wayland session";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = [];
      description = "Extra Hyprland config lines appended to hyprland.post.conf";
    };

    monitors = mkOption {
      type = types.listOf (types.attrsOf types.any);
      default = [];
      description = "List of monitors to configure";
    };

    mako = mkOption {
      type = types.attrsOf types.any;
      default = {};
      description = "Mako notification settings";
    };

    hyprlock = mkOption {
      type = types.attrsOf types.any;
      default = {};
      description = "Hyprlock configuration";
    };

    idle = mkOption {
      type = types.attrsOf types.int;
      default = {
        time = 600;
        autodpms = 1200;
        autolock = 2400;
        autosleep = 0;
      };
      description = "Idle timeouts in seconds";
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.type = "wayland";

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    hardware.graphics = {
      package = pkgs.unstable.mesa;
      package32 = pkgs.unstable.pkgsi686Linux.mesa;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.unstable.hyprland;
      portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    };

    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "systemctl --user suspend";
        after-resume = "";
        lock = "loginctl lock-session";
        unlock = "";
      };
      timeouts = [
        { timeout = cfg.idle.time; command = "echo idle-time"; resume = ""; }
        { timeout = cfg.idle.autodpms; command = "xset dpms force off"; resume = ""; }
        { timeout = cfg.idle.autolock; command = "loginctl lock-session"; }
        { timeout = cfg.idle.autosleep; command = "systemctl suspend"; }
      ];
    };

    services.waybar = {
      enable = true;
      primaryMonitor = primaryMonitor.output or "";
    };

    services.ydotool.enable = true;

    environment.systemPackages = with pkgs; [
      hyprlock
      hyprpicker
      hyprshade
      hyprshot
      mako
      swaybg
      xorg.xrandr
      gromit-mpx
      pamixer
      wlr-randr
    ];

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.writeShellScript "hyprland-wrapper" ''
          exec Hyprland >/dev/null
        ''}";
        user = config.user.name;
      };
    };

    environment.etc."greetd/environments".text = "Hyprland";

    home.file."hypr/hyprland.pre.conf".text = ''
      exec-once = true
      ${concatMapSep "\n" (m:
        if m.disable then "monitor = ${m.output},disable"
        else "monitor = ${m.output},${m.mode or "preferred"},${m.position or "auto"},${toString (m.scale or 1)}"
      ) cfg.monitors}

      $PRIMARY_MONITOR = ${primaryMonitor.output or ""}
    '';

    home.file."hypr/hyprland.post.conf".text = concatStringsSep "\n" cfg.extraConfig;

    home.file."hypr/hyprlock.conf".text = ''
      ${concatMapAttrsToString (n: v:
        if builtins.isAttrs v
        then "${n} {\n${concatMapAttrsToString (k: val: "  ${k} = ${toString val}\n") v}}\n"
        else ""
      ) cfg.hyprlock}
    '';

    home.file."mako/config".text = ''
      ${concatMapAttrsToString (n: v: "${n}=${toString v}\n") cfg.mako}
      [mode=dnd]
      invisible=1
    '';
  };
}
