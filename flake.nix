{
  description = "Dynamic NixOS and Home Manager configuration";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, xmonad-contrib, neovim-nightly-overlay, ... }: 
  let
    system = "x86_64-linux";
    overlays = [
      (import ./overlays/treesitter.nix)
      neovim-nightly-overlay.overlay
    ];
    pkgs = import nixpkgs {
      inherit system overlays;
    };

    hosts = [
      { host = "atlas"; configPath = ./hosts/atlas; user = "neon"; }
      { host = "x1"; configPath = ./hosts/x1; user = "neon"; }
    ];

    createConfig = hostEntry: {
      name = hostEntry.host;
      value = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostEntry.configPath/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${hostEntry.user} = import (hostEntry.configPath + "/home.nix") { pkgs = pkgs; home-manager = home-manager; };
          }
        ];
        # Pass explicitly required variables
        specialArgs = { inherit pkgs home-manager; };
      };
    };
  in {
    nixosConfigurations = builtins.listToAttrs (map createConfig hosts);
  };
}
