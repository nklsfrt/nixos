{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    gnome-initial-setup.enable = false;
  };

  environment.systemPackages = with pkgs; [
    clapper
    ptyxis
  ];

  systemd.user.units."org.gnome.Shell@wayland.service".text = ''
    [Service]
    ExecStart=
    ExecStart=${pkgs.gnome-shell.outPath}/bin/gnome-shell --no-x11
  '';

  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    seahorse.enable = true;
    file-roller.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
