{

  description = "My very first centralized infrastructure configuration!";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:{
    nixosConfigurations = {

      ashes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./ashes/ashes.nix
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useUserPackages = true;
          #   home-manager.users.nase = import ./ashes/home.nix;
          # }
        ];
      };

      timber = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./timber/timber.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.nase = import ./timber/home.nix;
          }
        ];
      };

    };
  };
}
