{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
  ];
  home.username = "nase";
  home.homeDirectory = "/home/niklas";
  home.stateVersion = "22.05";

  home.language = {
    base = "en_US.UTF-8";
    address = "de_DE.UTF-8";
    time = "de_DE.UTF-8";
    monetary = "de_DE.UTF-8";
    paper = "de_DE.UTF-8";
    numeric = "de_DE.UTF-8";
    measurement = "de_DE.UTF-8";    
  };

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

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    spotify
    htop
    librewolf
    pavucontrol
    helvum
    tdesktop
    signal-desktop
    bitwarden
    gnomeExtensions.gsconnect
    nil
  ];
}