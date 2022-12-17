{

  description = "My very first centralized infrastructure configuration!";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

  };

  outputs = { self, nixpkgs, home-manager, impermanence }:{
    nixosConfigurations = {

      ashes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./ashes/ashes.nix
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
            home-manager.users.nase = {
              imports = [ 
                impermanence.nixosModules.home-manager.impermanence
                ./timber/home/home.nix
              ];
            };
          }
          impermanence.nixosModules.impermanence
          {
            environment.persistence."/persist" = {
              hideMounts = true;
              directories = [
                "/etc/NetworkManager/system-connections/"
                "/etc/wireguard/"
              ];
            };
          }
        ];
      };

    };
  };
}
