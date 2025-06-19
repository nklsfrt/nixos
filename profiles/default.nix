{ lib, ... }:
with lib;
with builtins;
pipe ./. [
  readDir
  (filterAttrs (_: v: v == "directory"))
  (mapAttrs (name: _: import ./${name}))
]
