{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.enableDebug = false;
    systemd.enableInspect = false;
    systemd.target = "graphical-session.target";


        #home.configFile."waybar/style.css".source = ./config/waybar/style.css;
  settings = {
    main = {
      layer = "top";
      position = "top";
      height = 14;
      margin-bottom = 0;
      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
        "tray"
        "custom/spacer"
        "cpu"
        "custom/gpu-nvidia"
        "memory"
        "bluetooth"
        "network"
        "battery"
        "backlight"
        "pulseaudio"
        "idle_inhibitor"
        "clock"
        # "privacy"
      ];
      "tray" = {
        "icon-size" = 12;
        "spacing" = 4;
        "show-passive-items" = true;
      };
      # TODO: "custom/gpu-amd" = {}
      # TODO: "custom/gpu-intel" = {}
      "custom/gpu-nvidia" = {
        #"exec" = "${heyBin} exec nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
        "format" = " {}%";
        "return-type" = "";
        "interval" = 4;
      };
      "custom/spacer" = { "format" = " "; };
      "idle_inhibitor" = {
        "format" = "{icon}";
        "format-icons" = {
          "activated" = "";
          "deactivated" = "";
        };
      };
      "bluetooth" = {
        "format" = "";
        "format-disabled" = "";
        "format-connected" = " {num_connections}";
        "tooltip-format" = "{controller_alias}\t{controller_address}";
        "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
      };
      "hyprland/window" = {
        "format" = "{title}";
        "separate-outputs" = true;
      };
      "hyprland/workspaces" = {
        "active-only" = false;
        "all-outputs" = false;
        "disable-scroll" = true;
        "on-click" = "activate";
        "show-special" = false;
        "format" = "{icon}";
        "format-icons" = {
          "active" = "";
          "default" = "";
          "empty" = "";
          "urgent" = "";
          "special" = "";
        };
        "persistent-workspaces" = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
          "6" = [];
          "7" = [];
          "8" = [];
          "9" = [];
        };
      };
      "clock" = {
        "format" = "{:%H:%M - %a %d/%b}";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        "calendar" = {
          "mode"          = "year";
          "mode-mon-col"  = 3;
          "weeks-pos"     = "right";
          "on-scroll"     = 0;
          "format" = {
            "months"   = "<span color  ='#ffead3'><b>{}</b></span>";
            "days"     = "<span color='#ecc6d9'><b>{}</b></span>";
            "weeks"    = "<span color ='#99ffdd'><b>W{}</b></span>";
            "weekdays" = "<span color    ='#ffcc66'><b>{}</b></span>";
            "today"    = "<span color ='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        "actions" = {
          "on-click-right" = "mode";
        };
      };
      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon}";
        "format-icons" = ["" "" ""];
        "on-scroll-up" = "brightnessctl set 1%+";
        "on-scroll-down" = "brightnessctl set 1%-";
        "min-length" = 6;
      };
      "cpu" = {
        "format" = "<span weight='bold'></span> {usage}%";
      };
      "memory" = {
        "format" = "<span weight='bold'></span> {}%";
      };
      "battery" = {
        "bat" = "BAT0";
        "states" = {
          # "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "<span weight='bold'>{icon}</span> {capacity}%";
        # "format-good" = ""; // An empty format will hide the module
        # "format-full" = "";
        "format-icons" = ["" "" "" "" ""];
      };
      "pulseaudio" = {
        # "scroll-step" = 1;
        "format" = "<span weight='bold'>{icon}</span>";
        "format-bluetooth" = "<span weight='bold'>{icon}</span> {volume}%";
        "format-muted" = "<span weight='bold'></span>";
        "format-icons" = {
          "headphones" = "";
          "handsfree" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = ["" ""];
        };
        "on-click" = "pavucontrol";
      };
      "network" = {
        "format-disconnected" = "<span weight='bold'>⚠</span>";
        "format-ethernet" = "";
        "format-linked" = "";
        "format-wifi" = "<span weight='bold'></span> {signalStrength}%";
        "tooltip-format-ethernet" = " {ifname} via {gwaddr}";
        "tooltip-format-wifi" = " {essid}: {ifname} via {gwaddr}";
      };
    };
            #osd = {
            #  mode = "overlay";
            #  layer = "top";
            #  position = "bottom";
            #  width = 512;
            #  height = 200;
            #  margin-bottom = 220;
            #  "hyprland/submap".format = "{}";
            #  modules-center = [ "hyprland/submap" ];
            # };
  };


        #    settings = {
        #      mainBar = {
        #        layer = "top";
        #        position = "top";
        #        modules-left = [ "clock" ];
        #        modules-center = [ ];
        #        modules-right = [ "pulseaudio" "network" ];
        #      };
        #    };

    style = ''
      * {
        font-family: "Sans";
        font-size: 10px;
      }
    '';
  };

  home.file.".config/waybar/".source = ../config/waybar; 
  home.file.".config/waybar/".recursive = true; 

  programs.anyrun.config.ignoreExclusiveZones = true;
}
