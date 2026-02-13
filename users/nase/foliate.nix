{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.foliate ];
    persistence."/persist".directories = [ ".local/share/com.github.johnfactotum.Foliate" ];
  };
}
