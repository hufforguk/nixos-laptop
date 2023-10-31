{
  description = "My First Flake";
 
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ...  }:
    let
      lib = nixpkgs.lib;
    in {

  nixosConfigurations = {
      huff-nixos-laptop = lib.nixosSystem {
        system="x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}

