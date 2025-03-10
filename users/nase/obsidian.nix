{ pkgs, ... }:
{
  home.packages = [ pkgs.obsidian ];
  home.persistence."/persist/home/nase".directories = [ "Obsidian" ];
}
