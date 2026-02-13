{ pkgs, ... }:
{
  home = {
    packages = [ pkgs.discord-canary ];
    persistence."/persist".directories = [ ".config/discordcanary" ];
  };
}
