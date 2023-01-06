{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];


  boot = {

    loader.systemd-boot.enable = true;

    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

  };


  security.polkit.enable = true;
 
  networking.hostName = "forest";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

	services.qemuGuest.enable = true;

  zramSwap.enable = true;

  virtualisation.docker.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

}

