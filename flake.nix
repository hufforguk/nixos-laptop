{
  description = "Huff laptop flake";
  
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
 

    nix-gaming.url = "github:fufexan/nix-gaming";
    
    m4b-tools.url = "github:sandreas/m4b-tool";
    
    vpinball-flake.url = "github:raiford/vpinball-flake";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    home-manager = {
#     url = "github:nix-community/home-manager";
#      inputs.nixpkgs.follows = "nixpkgs";
 #   };

  };

  outputs = { self, nixpkgs, vpinball-flake, ... }@inputs:
    let lib = nixpkgs.lib;
    in {

      nixosConfigurations = {
        huff-nixos-laptop = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [ 
            ./configuration.nix 
            {
              nixpkgs.overlays = [ vpinball-flake.overlays.default ];
              nixpkgs.config.allowUnfree = true;  # Required for pinmame
            }

          ];
        };
      };
    };
}


