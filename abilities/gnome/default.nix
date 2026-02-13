{ lib, pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    gnome-initial-setup.enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnome-console
  ];

  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
    lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
      [
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        pkgs.gst_all_1.gst-libav
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
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
