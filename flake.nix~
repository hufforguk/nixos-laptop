{
  description = "My First Flake";
 
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  
  };
  

  outputs = { self, nixpkgs, ...  }:
    let
      lib = nixpkgs.lib;
    in {

  nixosConfigurations = {
      huff-nixos-laptop = lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system="x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}

