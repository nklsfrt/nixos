{
  profiles,
  pkgs,
  inputs,
  ...
}: {
  imports = [profiles.laptop];

  fileSystems."/persist".neededForBoot = true;

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
