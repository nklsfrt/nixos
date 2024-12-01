{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.discord-canary ];
    persistence."/persist/home/niklas".directories = [ ".config/discordcanary" ];
  };
}
