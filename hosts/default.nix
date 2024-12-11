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

  # Define shared packages (Neovim and Git) to be installed on all hosts
  environment.systemPackages = with pkgs; [
    git
  ];
}

