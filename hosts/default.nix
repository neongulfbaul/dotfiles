# /etc/nixos/hosts/default.nix

{ lib, inputs, outputs, pkgs, home-manager, ... }: {
  # Configure nixpkgs options, allowing unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  # home-manager stuff that probably doesn't work
  #home-manager.nixosModules.home-manager
  #  {
  #    home-manager.useGlobalPkgs = true;
  #    home-manager.useUserPackages = true;
  #    home-manager.extraSpecialArgs = extraArgs;
  #    home-manager.stateVersion = 24.05;
  #    home-manager.users.${user} = {
  #     imports = [
  #       ./home.nix
  #       ./${ host }/home.nix
  #       ];
 #       };
 #     };

  # Configure nix settings, including experimental features and garbage collection
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "neon"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  # Define shared packages (Neovim and Git) to be installed on all hosts
  environment.systemPackages = with pkgs; [
    git
  ];
}

