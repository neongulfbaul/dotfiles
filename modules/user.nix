# modules/user.nix
# Defines the primary user slot. Consumed by profiles/user/*.nix
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkOption mkIf types;
in {
  options.user = {
    name        = mkOption { type = types.str; };
    uid         = mkOption { type = types.int;    default = 1000; };
    home        = mkOption { type = types.str;    default = "/home/${config.user.name}"; };
    shell       = mkOption { type = types.package; default = pkgs.zsh; };
    timezone    = mkOption { type = types.str;    default = "UTC"; };
    locale      = mkOption { type = types.str;    default = "en_US.UTF-8"; };
    extraGroups = mkOption { type = types.listOf types.str; default = []; };
    packages    = mkOption { type = types.listOf types.package; default = []; };
  };

  config = {
    users.users.${config.user.name} = {
      isNormalUser = true;
      uid          = config.user.uid;
      home         = config.user.home;
      shell        = config.user.shell;
      extraGroups  = [ "wheel" "networkmanager" "video" "audio" ]
                     ++ config.user.extraGroups;
    };

    time.timeZone      = config.user.timezone;
    i18n.defaultLocale = config.user.locale;

    # user.packages lands in home via home.nix's HM wiring
    home-manager.users.${config.user.name}.home.packages = config.user.packages;
  };
}
