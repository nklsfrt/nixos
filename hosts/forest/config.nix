{ config, pkgs, ... }:
let
  router-ip = "192.168.69.1";
  lan-bridge = "bridge1";
  lan1 = "lan1";
  lan2 = "lan2";
  lan3 = "lan3";
  wan-nic = "wan";
in
{

  networking = {
    nameservers = [
      "76.76.2.11#p2.freedns.controld.com"
    ];
    hostId = "90af6e90";
    nat = {
      enable = true;
      internalInterfaces = [ lan-bridge ];
      externalInterface = wan-nic;
    };
    firewall.trustedInterfaces = [ lan-bridge ];
    nftables.enable = true;
    useNetworkd = true;
  };

  systemd.network = {
    config.networkConfig.IPv6PrivacyExtensions = true;
    enable = true;
    links = {
      "10-${wan-nic}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:9f";
        linkConfig.Name = "${wan-nic}";
      };
      "10-${lan1}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a0";
        linkConfig.Name = lan1;
      };
      "10-${lan2}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a1";
        linkConfig.Name = lan2;
      };
      "10-${lan3}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a2";
        linkConfig.Name = lan3;
      };
    };
    netdevs = {
      "20-${lan-bridge}" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "${lan-bridge}";
        };
      };
    };
    networks = {
      "30-${wan-nic}" = {
        matchConfig.Name = "${wan-nic}";
        networkConfig = {
          DHCP = "yes";
          IPForward = "yes";
          IPv6AcceptRA = "yes";
        };
        dhcpV6Config = {
          PrefixDelegationHint = "::/64";
        };
      };
      "30-${lan1}" = {
        matchConfig.Name = lan1;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "30-${lan2}" = {
        matchConfig.Name = lan2;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "30-${lan3}" = {
        matchConfig.Name = lan3;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "40-${lan-bridge}" = {
        matchConfig.Name = "${lan-bridge}";
        networkConfig = {
          IPForward = "yes";
          ConfigureWithoutCarrier = "yes";
          Address = "${router-ip}/24";
          DHCPServer = "yes";
          IPv6SendRA = "yes";
          DHCPPrefixDelegation = "yes";
        };
        dhcpPrefixDelegationConfig = {
          UplinkInterface = "wan";
        };
        dhcpServerConfig = {
          DNS = router-ip;
          PoolOffset = 100;
          Router = router-ip;
        };
        ipv6SendRAConfig = {
          EmitDNS = "yes";
          DNS = "_link_local";
        };
        # linkConfig.RequiredForOnline = "no-carrier";
      };
    };
  };

  services = {

    resolved = {
      enable = true;
      dnssec = "true";
      llmnr = "false";
      dnsovertls = "true";
      fallbackDns = [ "1.0.0.1" "2606:4700:4700::1001" ];
      extraConfig = "DNSStubListenerExtra=${router-ip}\nDNSStubListenerExtra=fe80::492:b5ff:fe49:7944";
    };

    netdata = {
      enable = true;
      config = {
        web = {
          "bind to" = "127.0.0.1:19999";
        };
      };
    };

    paperless = {
      enable = true;
      passwordFile = config.sops.secrets.paperless_admin_password.path;
    };

    caddy = {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        mon.lan {
          tls internal
          reverse_proxy 127.0.0.1:19999
        }
        agh.lan {
          tls internal
          reverse_proxy 127.0.0.1:3000
        }
        paper.lan {
          tls internal
          reverse_proxy 127.0.0.1:28981
        }
      '';
    };

    zfs.autoScrub.enable = true;
  };

  sops.secrets = {
    paperless_admin_password = { };
  };
}
