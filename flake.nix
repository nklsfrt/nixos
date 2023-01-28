{

  description = "My very first centralized infrastructure configuration!";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    website = {
      url = "git+https://codeberg.org/nklsfrt/nklsfrt.de\?ref=main";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, impermanence, website }:{
    nixosConfigurations = {
      ashes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit website; };
        modules = [
          ./common.nix
          ./ashes/ashes.nix
        ];
      };

      forest = nixpkgs.lib.nixosSystem {
      	system = "x86_62-linux";
      	modules = [
      	  ./common.nix
      	  ./forest/forest.nix
      	];
      };

      driftwood = nixpkgs.lib.nixosSystem {
      	system = "x86_64-linux";
      	modules = [
      	  ./common.nix
      	  ./driftwood/driftwood.nix
      	  home-manager.nixosModules.home-manager
      	  {
      	    home-manager.useUserPackages = true;
      		home-manager.users.nase = {
      		  imports = [ ./driftwood/home/home.nix ];
      		};
      	  }
      	];
      };

      timber = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./timber/timber.nix
          impermanence.nixosModules.impermanence
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
        ];
      };

    };
  };
}
