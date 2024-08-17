{ config, pkgs, ... }:
let
  router-ipv4 = "192.168.69.1";
  router-ipv6 = "2001:9e8:e126:d7ff:492:b5ff:fe49:7944";
  lan-bridge = "bridge1";
  lan1 = "lan1";
  lan2 = "lan2";
  lan3 = "lan3";
  wan-nic = "wan";
in
{

  networking = {
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
          Address = "${router-ipv4}/24";
          DHCPServer = "yes";
          IPv6SendRA = "yes";
          DHCPPrefixDelegation = "yes";
        };
        dhcpPrefixDelegationConfig = {
          UplinkInterface = "wan";
        };
        dhcpServerConfig = {
          DNS = router-ipv4;
          PoolOffset = 100;
          Router = router-ipv4;
        };
        ipv6SendRAConfig = {
          EmitDNS = "yes";
          DNS = "${router-ipv6}";
        };
        # linkConfig.RequiredForOnline = "no-carrier";
      };
    };
  };

  services = {

    adguardhome = {
      enable = true;
      mutableSettings = false;
      settings = {
        # http.address = "localhost";
        dns = {
          bind_hosts = [
            "${router-ipv4}"
            "${router-ipv6}"
          ];
          port = 53;
          upstream_dns = [ "quic://p2.freedns.controld.com" ];
          bootstrap_dns = [
            "9.9.9.9"
            "2620:fe::fe"
          ];
          bootstrap_prefer_ipv6 = true;
          fallback_dns = [
            "9.9.9.9"
            "2620:fe::fe"
          ];
          enable_dnssec = true;
          serve_http3 = true;
        };
        tls = {
          enabled = true;
        };
        filtering.rewrites = [
          {
            domain = "*.lan";
            answer = "${router-ipv4}";
          }
          {
            domain = "*.lan";
            answer = "${router-ipv6}";
          }
        ];
      };
    };

    netdata = {
      enable = true;
      config = {
        web = {
          "bind to" = "localhost:19999";
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
          reverse_proxy localhost:19999
        }
        agh.lan {
          tls internal
          reverse_proxy localhost:3000
        }
        paper.lan {
          tls internal
          reverse_proxy localhost:28981
        }
      '';
    };

    zfs.autoScrub.enable = true;
  };

  sops.secrets = {
    paperless_admin_password = { };
  };
}
