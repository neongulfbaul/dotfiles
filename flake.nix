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

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

    hosts = [
      { host = "atlas"; configPath = ./hosts/atlas; user = "neon"; }
      { host = "x1"; configPath = ./hosts/x1; user = "neon"; }
    ];

    createConfig = hostEntry: {
      name = hostEntry.host;
      value = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/default.nix
          (import "${hostEntry.configPath}/default.nix")
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${hostEntry.user} = import "${hostEntry.configPath}/home.nix" {
              inherit pkgs;
            };
          }
        ];
        # Ensure specialArgs does not conflict with _module.args
        specialArgs = {
          pkgs = pkgs;
          home-manager = home-manager;
          nixos-hardware = nixos-hardware;
            };
      };
    };
  in {
    nixosConfigurations = builtins.listToAttrs (map createConfig hosts);
  };
}

