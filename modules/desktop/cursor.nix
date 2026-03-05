{ config, lib, pkgs, ... }:

let
  cursorPkg = pkgs.catppuccin-cursors.mochaDark;
  cursorName = "catppuccin-mocha-dark-cursors";
  cursorSize = 24;
in
{
  options.modules.desktop.cursor = {
    enable = lib.mkEnableOption "Custom cursor theme";
  };

  config = lib.mkIf config.modules.desktop.cursor.enable {
    home.pointerCursor = {
      name = cursorName;
      package = cursorPkg;
      size = cursorSize;
    };

    # Export for Wayland / XWayland apps
    home.sessionVariables = {
      XCURSOR_THEME = cursorName;
      XCURSOR_SIZE = builtins.toString cursorSize;
    };

    # Export for Hyprland
    wayland.windowManager.hyprland.settings.env = [
      "HYPRCURSOR_THEME,${cursorName}"
      "HYPRCURSOR_SIZE,${builtins.toString cursorSize}"
    ];
  };
}
