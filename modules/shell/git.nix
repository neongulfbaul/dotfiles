{ lib, config, pkgs, ... }:

with lib;
let 
  cfg = config.modules.shell.git;
  # Define the user variable exactly like in hyprland.nix 
  user = config.user.name; 
  configDir = ../../config; 
in {
  options.modules.shell.git = {
    enable = mkEnableOption "Git shell module";
  };

  config = mkIf cfg.enable {
    # 1. Custom top-level configFile (moved outside the HM block as requested)
    home.configFile = {
      "git/config".source     = "${configDir}/git/config";
      "git/ignore".source     = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    # 2. Home-manager level (Matches hyprland.nix structure [cite: 16])
    home-manager.users.${user} = {
      # This matches how you install packages in hyprland.nix 
      home.packages = with pkgs; [
        diff-so-fancy
        gh
        git-annex
        git-open
        act
        (mkIf (config.modules.shell ? gnupg && config.modules.shell.gnupg.enable) git-crypt)
      ];
    };
};
}
