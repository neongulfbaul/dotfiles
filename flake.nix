{
  description = "blatantly ripped from https://github.com/hlissner/dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    quickshell.url = "github:quickshell-mirror/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... } @ inputs: 
    let
      hosts = [ "atlas" "x1" "wsl" ];
      
      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./default.nix
          ./modules
          ./hosts/${host} 
          (nixpkgs.lib.optionalAttrs (host == "wsl") nixos-wsl.nixosModules.default)
        ];
      };
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;

      nixosModules = {
        default = ./default.nix;
        home = ./modules/home.nix;
        options = ./modules/default-options.nix;
        shell = ./modules/shell;
        editors = ./modules/editors;
        profiles = ./modules/profiles;
        security = ./modules/security.nix;
        xdg = ./modules/xdg.nix;
        };
    };
}
