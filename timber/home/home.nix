{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
  ];
  home.username = "nase";
  home.homeDirectory = "/home/niklas";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}