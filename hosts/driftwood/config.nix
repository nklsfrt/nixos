{ profiles, pkgs, ... }:
{
  imports = [ profiles.graphical ];

  boot.plymouth.enable = true;
  services.thermald.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  systemd.user.services = {
    set-brightness = {
      description = "Sets the default screen brightness.";
      wantedBy = [ "gnome-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'echo 200 > /sys/class/backlight/intel_backlight/brightness'";
      };
    };
    set-power-profile = {
      description = "Sets the default power-profile.";
      wantedBy = [ "gnome-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
