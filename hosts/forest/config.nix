{ config, pkgs, ... }:

{
  
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "rpool" ];
  networking.hostId = "10fa8e3e";
  boot.loader.systemd-boot.enable = true;

  security.polkit.enable = true;


  system.stateVersion = "22.05"; # Did you read the comment?

}

