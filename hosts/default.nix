{ lib, inputs, outputs, pkgs, home-manager, ... }: 

{
  nixpkgs.config.allowUnfree = true;    
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

  environment.systemPackages = with pkgs; [
    git
  ];
}

