{

  description = "nklsfrt's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    website = { url = "git+https://codeberg.org/nklsfrt/nklsfrt.de\?ref=main"; flake = false; };
  };

  outputs = inputs:
  {
    nixosConfigurations = import ./hosts { inherit inputs; };
  };
}


