{ config, pkgs, ... }:
let
  router-ipv4 = "192.168.69.1";
  router-ula = "fd5e:08d3:3e55::1"; # first /64 subnet of fd5e:08d3:3e55::/48
  lan-bridge = "bridge1";
  lan1 = "lan1";
  lan2 = "lan2";
  lan3 = "lan3";
  wan-nic = "wan";
  domain = "home.arpa";
in
{

  networking = {
    hostId = "90af6e90";
    nat = {
      enable = true;
      internalInterfaces = [ lan-bridge ];
      externalInterface = wan-nic;
    };
    firewall = {
      trustedInterfaces = [ lan-bridge ];
      filterForward = true;
    };
    nftables.enable = true;
    useNetworkd = true;
  };

  systemd.network = {
    config.networkConfig = {
      IPv6PrivacyExtensions = true;
      IPv6Forwarding = "yes";
    };
    enable = true;
    links = {
      "10-${wan-nic}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:9f";
        linkConfig.Name = wan-nic;
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
          IPv4Forwarding = "yes";
          IPv6AcceptRA = "yes";
          IPv6LinkLocalAddressGenerationMode = "stable-privacy";
        };
        ipv6AcceptRAConfig = {
          Token = "prefixstable";
          DHCPv6Client = "always";
        };
        dhcpV6Config = {
          UseAddress = "no";
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
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv4Forwarding = "yes";
          ConfigureWithoutCarrier = "yes";
          LinkLocalAddressing = "ipv6";
          IPv6LinkLocalAddressGenerationMode = "stable-privacy";
          DHCPServer = "yes";
          IPv6SendRA = "yes";
          DHCPPrefixDelegation = "yes";
        };
        dhcpPrefixDelegationConfig = {
          UplinkInterface = "wan";
          Token = "prefixstable";
        };
        dhcpServerConfig = {
          DNS = router-ipv4;
          PoolOffset = 100;
          Router = router-ipv4;
        };
        ipv6SendRAConfig = {
          EmitDNS = "yes";
          DNS = "${router-ula}";
        };
        ipv6Prefixes = [
          {
            Prefix = "fd5e:08d3:3e55::/64";
            Assign = true;
            Token = "static:::1";
          }
        ];
        address = [
          "${router-ipv4}/24"
        ];
      };
    };
  };

  services = {
    adguardhome = {
      enable = true;
      mutableSettings = false;
      host = "127.0.0.1";
      port = 3000;
      settings = {
        dns = {
          bind_hosts = [
            "${router-ipv4}"
            "${router-ula}"
          ];
          port = 53;
          upstream_dns = [
            "quic://p2.freedns.controld.com"
            "quic://dns0.eu"
          ];
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
            domain = "*.${domain}";
            answer = "${router-ipv4}";
          }
          {
            domain = "*.${domain}";
            answer = "${router-ula}";
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
      settings = {
        PAPERLESS_URL = "https://paper.${domain}";
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
      };
      passwordFile = config.sops.secrets.paperless_admin_password.path;
    };

    caddy = {
      enable = true;
      configFile = pkgs.writeText "Caddyfile" ''
        mon.${domain} {
            tls internal
            reverse_proxy localhost:61208
        }
        agh.${domain} {
            tls internal
            reverse_proxy localhost:3000
        }
        paper.${domain} {
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
