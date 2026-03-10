{
  description = "flake for NixOS";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, ... }: let
    overlays = [ (import ./overlays/treesitter.nix) ];
    # Use specialArgs to pass inputs globally to all modules
    specialArgs = { inherit inputs; }; 
  in {
    nixosConfigurations = {
      atlas = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/atlas  # This now contains your system + HM config
        ];
      };

      x1 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./hosts/x1     # Assuming you follow the same pattern for the X1
        ];
      };
    };
  };
}
