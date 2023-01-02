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

  home.sessionVariables.NIXOS_OZONE_WL = "1"; # Launch (recent) electron-applications with wayland support.

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Iosevka Term:size=11";
      };
      colors.alpha = 0.8;
    };
  };

  accounts.email.accounts = {
    posteo = {
      primary = true;
      address = "furtwaengler@posteo.de";
      userName = "furtwaengler@posteo.net";
      smtp.host = "posteo.de";
      smtp.port = 465;
      smtp.tls.enable = true;
      imap.host = "posteo.de";
      imap.port = 993;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "furtwaengler@posteo.de";
    userName = "Niklas Furtwängler";
    signing = {
      key = "2FDF 6458 1DBA 9A81 366F ED34 895D 6A61 1B8A F8AB";
      signByDefault = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "nix.enableLanguageServer" = "true";
      "nix.serverPath" = "nil";
    };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      matklad.rust-analyzer
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.niklas = {
      name = "niklas";
      path = "vlqejqkk.niklas";
    };
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    spot
    htop
    pavucontrol
    easyeffects
    helvum
    tdesktop
    signal-desktop
    onlyoffice-bin
    rustc
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
  
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  
}
