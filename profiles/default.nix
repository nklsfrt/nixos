{ lib, ... }:
with lib;
with builtins;
pipe ./. [
  readDir
  (filterAttrs (n: v: v == "directory"))
  (mapAttrs (name: _: import ./${name}))
]
