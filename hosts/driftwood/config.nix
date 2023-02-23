{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../users/nase/home.nix
    ../../modules/gnome
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
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

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    iosevka-bin
  ];

  system.stateVersion = "22.05"; # Did you read the comment?
  system.autoUpgrade.persistent = true;
}
