{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];


  boot = {

    loader.systemd-boot.enable = true;

    loader.efi.canTouchEfiVariables = true;

    supportedFilesystems = [ "zfs" ];

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  };

  virtualisation = {
  	libvirtd.enable = true;
  };

  security.polkit.enable = true;
 
  networking = {

  	hostName = "forest";
  	
	hostId = "795ee55c";
	
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };


  zramSwap.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?

}

