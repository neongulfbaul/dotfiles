# default.nix
{ lib, options, config, pkgs, ... }:
with lib;
{
  imports = [
    ./modules
  ];

  options = with types; {
    modules = {};
    # Creates a simpler, polymorphic alias for users.users.$USER.
    user = mkOption {
      type = attrs;  # Keep as attrs like Henrik does
      default = { name = ""; };
    };
  };

  config = {
    assertions = [{
      assertion = config.user ? name && config.user.name != "";
      message = "config.user.name is not set!";
    }];

    environment.sessionVariables = mkOrder 10 {
      DOTFILES_HOME = toString ./.;
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    # Default user settings (overridden by profiles)
    user = {
      description = mkDefault "The primary user account";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      uid = 1000;
    };

    # The magic aliasing!
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    # Core NixOS configuration
    fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

    nix = {
      extraOptions = ''
        warn-dirty = false
        experimental-features = nix-command flakes
      '';
      settings = {
        trusted-users = [ "root" config.user.name ];
        allowed-users = [ "root" config.user.name ];
        auto-optimise-store = true;
      };
    };

    system.stateVersion = "25.11";

    boot = {
      kernelPackages = mkDefault pkgs.linuxPackages_latest;
      loader = {
        efi.canTouchEfiVariables = mkDefault true;
        systemd-boot.configurationLimit = mkDefault 10;
      };
    };

    hardware.enableRedistributableFirmware = true;
  };
}
