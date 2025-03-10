{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.discord-canary ];
    persistence."/persist/home/nase".directories = [ ".config/discordcanary" ];
  };
}
