{
  description = "I stole this, then made chatgpt delete it and start again, it probably doesn't work.";

  # Define only essential inputs here
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    #nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";
  };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, xmonad-contrib, nixvim, ... }: 
  let
    args = {
     inherit self;
     inherit (nixpkgs);
    };
    pkgs = import nixpkgs { inherit system; };
    system = "x86_64-linux";
    
  in {
    nixosConfigurations = {
      atlas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
	  ./hosts/atlas/default.nix 
	  home-manager.nixosModules.home-manager
	];
        specialArgs = { inherit inputs home-manager; };
      };
      x1 = nixpkgs.lib.nixosSystem {
     	system = "x86_64-linux";
        modules = [ 
        ./hosts
        ./hosts/x1
	    home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.neon = import ./hosts/x1/home.nix;
        }
             ] ++ xmonad-contrib.nixosModules ++ [ 
        ]; 
        specialArgs = { inherit inputs home-manager; };
      };
    };
  };
}
