{
  description = "Minimal flake for NixOS with Home Manager modules";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, ... }: let
    overlays = [ (import ./overlays/treesitter.nix) ];
    pkgsFor = system: import nixpkgs { inherit system overlays; };
  in {
    nixosConfigurations = {
      atlas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/atlas
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.neon = import ./hosts/atlas/home.nix; 
          }
        ];
        specialArgs = { inherit home-manager; };
      };

      x1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/x1
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.neon = import ./hosts/x1/home.nix;
          }
        ];
        specialArgs = { inherit inputs home-manager; };
      };
    };
  };
}
