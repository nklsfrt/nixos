{pkgs, ...}: {
  imports = [
    ./dconf.nix
    ./firefox.nix
    ./fish.nix
    ./foot.nix
    ./git.nix
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
    spot
    pavucontrol
    easyeffects
    tdesktop
    signal-desktop
    onlyoffice-bin
    nil
    evolution
    parsec-bin
  ];

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
}
