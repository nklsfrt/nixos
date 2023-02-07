{

  description = "My very first centralized infrastructure configuration!";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";

    website = {
      url = "git+https://codeberg.org/nklsfrt/nklsfrt.de\?ref=main";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, impermanence, sops-nix, website }:{
    nixosConfigurations =
    let
      systems = builtins.attrNames (nixpkgs.lib.filterAttrs (n: v: v == "directory" && n != ".git" ) (builtins.readDir ./.));
    in
    { nameValuePair name lib.nixosSystem
      
      
      
      
      
      
      
      name = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./${name}/${name}.nix
        ];
      };
    };
  };
}


