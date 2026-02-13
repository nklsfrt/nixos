{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.vesktop ];
    persistence."/persist".directories = [ ".config/vesktop" ];
  };
}
