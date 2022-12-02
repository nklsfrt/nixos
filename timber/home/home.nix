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
    pavucontrol
    helvum
    tdesktop
    signal-desktop
    bitwarden
    nil
    firefox
    evolution
    evolution-data-server
  ];

  programs.fish = {
    enable = true;
    functions = {
      sshmux = {
        description = "Launches a remote tmux session or attaches to an existing one.";
        body = "ssh -t $argv systemd-run --scope --user tmux new -A -s ssh";
      };
      winreboot = {
        description = "Reboot the auto generated Windows boot entry.";
        body =  "systemctl reboot --boot-loader-menu=1 --boot-loader-entry=auto-windows";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host ashes
      HostName 2a01:4f8:1c1c:4bd6::1
    '';
  };
  
}