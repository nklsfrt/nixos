{ pkgs, ... }:
{
  home.packages = [ pkgs.obsidian ];
  home.persistence."/persist".directories = [ "Obsidian" ];
}
