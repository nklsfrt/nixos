{ config, pkgs, ... }:
let
  wan-nic = "enp2s0";
  lan-nics = [ "enp3s0" "enp4s0" "enp5s0" ];
  lan-bridge = "br0";
  router-ip = "192.168.69.1";
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
        useDHCP = true;
        ipv4.addresses = [ { address = "${router-ip}"; prefixLength = 24; }];
      };
      enp2s0.useDHCP = true;
    };
    firewall = {
      trustedInterfaces = [ "${lan-bridge}" ];
    };
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      bind_address = [ "192.168.69.1" ];
      bind_port = 3000;
    };
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

  system.stateVersion = "22.05"; # Did you read the comment?

}

