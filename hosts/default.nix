{
  inputs,
  abilities,
  profiles,
  users,
  ...
}:
with inputs;
with nixpkgs.lib;
with builtins;
pipe ./. [
  readDir
  (filterAttrs (n: v: v == "directory"))
  (mapAttrs (
    name: _:
    nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit
          inputs
          abilities
          profiles
          users
          ;
      };
      modules =
        [
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          { networking.hostName = mkDefault name; }
          ./${name}/config.nix
          ./${name}/hardware.nix
          profiles.common
        ]
        ++ optional (builtins.pathExists ./${name}/home.nix) ./${name}/home.nix
        ++ optional (builtins.pathExists ./${name}/disks.nix) ./${name}/disks.nix;
    }
  ))
]
