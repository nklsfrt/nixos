{ pkgs, ... }:
{
  home.packages = [ pkgs.gapless ];
  dconf.settings = {
    "com/github/neithern/g4music" = {
      monitor-changes = true;
      rotate-cover = false;
      show-peak = false;
    };
  };
}
