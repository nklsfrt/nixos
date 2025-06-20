{
  description = "nklsfrt's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    devshells.url = "git+https://codeberg.org/nklsfrt/devshells";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    website = {
      url = "git+https://codeberg.org/nklsfrt/nklsfrt.de?ref=main";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      abilities = import ./abilities { inherit lib; };
      profiles = import ./profiles { inherit lib; };
      users = import ./users { inherit lib; };
    in
    {
      nixosConfigurations = import ./hosts {
        inherit
          inputs
          abilities
          profiles
          users
          ;
      };
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      devShells.x86_64-linux.default = inputs.devshells.devShells.x86_64-linux.default;
    };
}
