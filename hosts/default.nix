{ inputs, abilities, profiles, users, ...}:

with inputs;
with nixpkgs.lib;
with builtins;

pipe ./. [
  readDir
  (filterAttrs (n: v: v == "directory"))
  (mapAttrs (name: _: nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs abilities profiles users; };
    modules = [
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      { networking.hostName = mkDefault name; }
      ./${name}/config.nix
      ./${name}/hardware.nix
      profiles.common
    ];
  }))
]