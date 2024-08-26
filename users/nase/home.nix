{ inputs, pkgs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-index-database.hmModules.nix-index
    ./dconf.nix
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./obsidian.nix
    ./persistence.nix
    ./pywal.nix
    ./ssh.nix
    ./vscode.nix
  ];

  home = {
    username = "nase";
    homeDirectory = "/home/niklas";
    stateVersion = "22.05";
    language = {
      base = "en_US.UTF-8";
      address = "de_DE.UTF-8";
      time = "de_DE.UTF-8";
      monetary = "de_DE.UTF-8";
      paper = "de_DE.UTF-8";
      numeric = "de_DE.UTF-8";
      measurement = "de_DE.UTF-8";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "micro";
    };
  };

  home.packages = with pkgs; [
    easyeffects
    evolution
    nix-output-monitor
    onlyoffice-bin
    pavucontrol
    signal-desktop
    fractal
    spotify
    tdesktop
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "application/pdf" = ["zathura.desktop" "evince.desktop" "firefox.desktop"];
    };
  };

  programs.nix-index.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
