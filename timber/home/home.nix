{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
  ];
  home.username = "nase";
  home.homeDirectory = "/home/niklas";
  home.stateVersion = "22.05";

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Iosevka Term:size=12";
      };
      colors.alpha = 0.8;
    };
  };

  programs.git = {
    userEmail = "furtwaengler@posteo.de";
    userName = "Niklas Furtwängler";
  };

}