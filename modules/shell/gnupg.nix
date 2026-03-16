{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.gnupg;
  user = config.user.name;
in {
  options.modules.shell.gnupg = {
    enable   = mkEnableOption "GnuPG module";
    cacheTTL = mkOption {
      type = types.int;
      default = 3600; # 1hr
      description = "GPG agent cache time-to-live";
    };
  };

  config = mkIf cfg.enable {
    # 1. System level: Set the environment variable so all tools know where GPG lives
    environment.sessionVariables.GNUPGHOME = "$HOME/.config/gnupg";

    # 2. System level: Enable GPG agent
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-rofi.override {
        rofi = pkgs.rofi-unwrapped; # Swapped to wayland version for your setup
      };
    };

      # This uses your custom home.configFile alias from your home.nix [cite: 6, 20]
    home.configFile."gnupg/gpg-agent.conf".text = ''
      default-cache-ttl ${toString cfg.cacheTTL}
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
    };
}
