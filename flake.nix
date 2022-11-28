{

  description = "My very first centralized infrastructure configuration!";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:

    let
      system = "x86_64-linux";
    in {

    nixosConfigurations = {

      ashes = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./common.nix
         ./ashes/ashes.nix
        ];
      };

      timber = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./common.nix
          ./timber/timber.nix
        ];
      };

    };
  };
}
