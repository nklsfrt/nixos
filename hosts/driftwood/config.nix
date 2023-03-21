{
  profiles,
  pkgs,
  inputs,
  ...
}: {
  imports = [profiles.graphical];

  boot.plymouth.enable = true;
  services.thermald.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
