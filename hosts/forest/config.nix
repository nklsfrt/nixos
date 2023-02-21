{ lib, config, pkgs, ... }:
let
  wan-nic = "enp2s0";
  lan-nics = [ "enp3s0" "enp4s0" "enp5s0" ];
  lan-bridge = "br0";
  router-ip = "192.168.69.1";
  wan-ports = [];
in
{
  
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "rpool" ];
  networking.hostId = "10fa8e3e";
  boot.loader.systemd-boot.enable = true;

  security.polkit.enable = true;

  boot = {
    kernel = {
      sysctl =  {
        "net.ipv4.conf.${wan-nic}.forwarding" = true;
        "net.ipv6.conf.${wan-nic}.forwarding" = true;
        "net.ipv4.conf.${lan-bridge}.forwarding" = true;
        "net.ipv6.conf.${lan-bridge}.forwarding" = true;
      };
    };
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "${lan-bridge}" ];
      externalInterface = wan-nic;
    };
    bridges = {
      "${lan-bridge}" = {
        interfaces = lan-nics;
      };
    };
    interfaces = {
      "${lan-bridge}" = {
        ipv4.addresses = [ { address = "${router-ip}"; prefixLength = 24; }];
      };
      "${wan-nic}" = {
        useDHCP = true;
      };
    };
    firewall = {
      trustedInterfaces = [ "${lan-bridge}" ];
      interfaces = {
        "${wan-nic}" = {
          allowedTCPPorts = lib.mkForce wan-ports;
          allowedUDPPorts = lib.mkForce wan-ports;
        };
      };
    };
  };

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };

  services.openssh.listenAddresses = [ { addr = "${router-ip}";} ];

  services.adguardhome = {
    enable = true;
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "${lan-bridge}" ];
    extraConfig = ''
    option domain-name-servers ${router-ip};
    option routers ${router-ip};
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.69.255;
    subnet 192.168.69.0 netmask 255.255.255.0 {
      range 192.168.69.10 192.168.69.99;
    }
    '';
  };

  virtualisation = {
    docker.extraOptions = "--ip ${router-ip}";
    oci-containers = {
      backend = "docker";
      containers = {
        reverse_proxy = {
          image = "traefik:v2.9.8";
          ports = [ "${router-ip}:80:80" ];
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.traefik.entrypoints=web"
            "--label=traefik.http.routers.traefik.rule=Host(`hub.lan`)"
            "--label=traefik.http.routers.traefik.service=api@internal"
            "--label=traefik.http.services.traefik.loadbalancer.server.port=8080"
          ];
          cmd = [
            "--api.dashboard=true"
            "--providers.docker=true"
            "--providers.docker.exposedbydefault=false"
            "--entrypoints.web.address=:80"
          ];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];
        };
        syncthing = {
          image = "syncthing/syncthing";
          volumes = [ "syncthing_data:/var/syncthing" ];
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.routers.syncthing.entrypoints=web"
            "--label=traefik.http.services.syncthing.loadbalancer.server.port=8384"
            "--label=traefik.http.routers.syncthing.rule=Host(`sync.lan`)"
          ];
        };
      };
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
