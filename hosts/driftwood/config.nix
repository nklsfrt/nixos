{
  pkgs,
  inputs,
  abilities,
  users,
  ...
}: {
  imports = with abilities; [
    audio
    fonts
    gnome
    persistence
    printing
    users.nase
  ];

  boot.plymouth.enable = true;
  services.thermald.enable = true;

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
