{ config, lib, pkgs, ... }:

let
  user = config.user.name;
  
  # Define the wrapped package
  # We use symlinkJoin to create a new package that points to the original 
  # but includes our specific environment variable fix for Wayland/Hyprland.
  en-croissant-wrapped = pkgs.symlinkJoin {
    name = "en-croissant-wrapped";
    paths = [ pkgs.en-croissant ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/en-croissant \
        --set WEBKIT_DISABLE_COMPOSITING_MODE "1"
    '';
  };

in {
  options.modules.desktop.apps.chess = {
    enable = lib.mkEnableOption "chess apps (en-croissant)";
  };

  config = lib.mkIf config.modules.desktop.apps.chess.enable {
    home-manager.users.${user} = {
      home.packages = [
        en-croissant-wrapped
      ];
    };

    # Documentation/Context for why we are doing this:
    # 1. En Croissant is a Tauri/WebKitGTK app.
    # 2. On Wayland (specifically Hyprland), WebKitGTK often fails to initialize 
    #    hardware acceleration correctly, leading to immediate 'abends' or segfaults.
    # 3. WEBKIT_DISABLE_COMPOSITING_MODE=1 forces a stable rendering path.
  };
}
