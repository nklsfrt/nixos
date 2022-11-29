{ config, pkgs, lib, ... }:

{
  home.username = "nase";
  home.homeDirectory = "/home/niklas";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  dconf.settings = {
    "/org/gnome/desktop/input-sources/sources" = lib.hm.gvariant.mkArray lib.hm.gvariant.type.tupleOf lib.hm.gvariant.type.string lib.hm.gvariant.mkTuple [ "xkb" "de" ];
  };
}bat