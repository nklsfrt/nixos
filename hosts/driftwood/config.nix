{ config, abilities, pkgs, inputs, ... }:

{
  imports = [
    ../../user-profiles/nase/home.nix
    abilities.gnome
    abilities.pipewire
  ];

  boot.plymouth.enable = true;

  networking.networkmanager.enable = true;

  hardware.opengl = {
  	enable = true;
  	extraPackages = with pkgs; [
  	  intel-media-driver
  	  vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
  	];
  };

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  fonts.fonts = with pkgs; [
    fira-code
  ];

  system.stateVersion = "22.05"; # Did you read the comment?
  system.autoUpgrade.persistent = true;

}
