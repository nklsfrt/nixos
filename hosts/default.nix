{inputs, ...}:

with inputs.nixpkgs;
with lib;
with builtins;

pipe ./. [
  readDir
  (filterAttrs (n: v: v == "directory"))
  (mapAttrs (name: _: nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = with inputs; [
      { networking.hostName = mkDefault name; }
      ./common.nix
      ./${name}/config.nix
      ./${name}/hardware.nix
    ];
  }))
]