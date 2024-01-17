{
  description = "Huff laptop flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";


    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, ... }@inputs:
    let lib = nixpkgs.lib;
    in {

      nixosConfigurations = {
        huff-nixos-laptop = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [ 
            ./configuration.nix 
            ./core.nix
          ];
        };
      };
    };
}


