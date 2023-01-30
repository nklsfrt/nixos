{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];


  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;

  security.polkit.enable = true;
 
  networking.hostName = "forest";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  services.qemuGuest.enable = true;

  zramSwap.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

  virtualisation = {
    docker.enable = true;
  };

}

