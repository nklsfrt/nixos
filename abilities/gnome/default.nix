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
    sushi.enable = true;
    gnome-initial-setup.enable = false;
    gnome-remote-desktop.enable = false;
    gnome-user-share.enable = false;
    rygel.enable = false;
  };

  services.avahi.enable = false;
  services.geoclue2.enable = false;

  environment.systemPackages = with pkgs.gnome; [
    gnome-calculator
    pkgs.gnome-photos
    gnome-music
    nautilus
    simple-scan
  ];

  programs.seahorse.enable = true;
  programs.file-roller.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;
}
