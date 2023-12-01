{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    core-utilities.enable = false;
    gnome-initial-setup.enable = false;
    gnome-remote-desktop.enable = false;
    gnome-user-share.enable = false;
    rygel.enable = false;
    sushi.enable = true;
  };

  services.geoclue2.enable = false;

  environment.systemPackages = with pkgs.gnome; [
    gnome-calculator
    pkgs.loupe
    gnome-music
    nautilus
    simple-scan
  ];

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
