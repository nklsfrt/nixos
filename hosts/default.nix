{
  inputs,
  abilities,
  users,
  ...
}:
with inputs;
with nixpkgs.lib;
with builtins;
  pipe ./. [
    readDir
    (filterAttrs (n: v: v == "directory"))
    (mapAttrs (name: _:
      nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs abilities users;};
        modules = [
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          {networking.hostName = mkDefault name;}
          ./common.nix
          ./${name}/config.nix
          ./${name}/hardware.nix
        ];
      }))
  ]
