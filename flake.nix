{
  description = "blatantly ripped from https://github.com/hlissner/dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @ inputs: 
    let
      hosts = [ "atlas" "x1" ];
      
      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${host} 
        ];
      };
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
