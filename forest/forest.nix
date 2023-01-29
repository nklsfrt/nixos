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
    oci-containers = {
      backend = "docker";
      containers = {
        traefik = {
          image = "traefik:v2.9.6";
          cmd = ["--providers.docker"];
          ports = ["80"];
          volumes = ["/var/run/docker.sock:/var/run/docker.sock"];
        };
        firefy = {
          image = "fireflyiii/core:version-5.7.18";
        };
        paperless = {
          image = "paperlessngx/paperless-ngx:1.12";
        };
      };
    };
  };

}

