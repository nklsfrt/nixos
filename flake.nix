{
  description = "nklsfrt's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    website = {
      url = "git+https://codeberg.org/nklsfrt/nklsfrt.de?ref=main";
      flake = false;
    };
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;
    abilities = import ./abilities {inherit lib;};
    profiles = import ./profiles {inherit lib;};
    users = import ./users {inherit lib;};
  in {
    nixosConfigurations =
      import ./hosts {inherit inputs abilities profiles users;};
    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
