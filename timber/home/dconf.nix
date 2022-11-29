{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "de" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };
  };
}