{ pkgs, ... }:
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
          IPForward = true;
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
          IPForward = true;
          Address = "${router-ip}/24";
        };
        linkConfig.RequiredForOnline = "no-carrier";
      };
    };
  };

  services = {

    adguardhome = {
      enable = true;
      mutableSettings = false;
      settings = {
        # http.address = "127.0.0.1";
        dns = {
          bind_hosts = [ "${router-ip}" ];
          port = 53;
          upstream_dns = [ "quic://p2.freedns.controld.com" ];
          bootstrap_dns = [
            "9.9.9.10"
            "149.112.112.10"
          ];
          enable_dnssec = true;
        };
        filtering.rewrites = [
          {
            domain = "*.lan";
            answer = "${router-ip}";
          }
        ];
      };
    };

    kea.dhcp4 = {
      enable = true;
      settings = {
        option-data = [
          {
            name = "domain-name-servers";
            data = "${router-ip}";
            always-send = true;
          }
          {
            name = "routers";
            data = "${router-ip}";
            always-send = true;
          }
        ];
        interfaces-config.interfaces = [ "${lan-bridge}" ];
        subnet4 = [
          {
            id = 1;
            subnet = "192.168.69.0/24";
            pools = [ { pool = "192.168.69.101 - 192.168.69.254"; } ];
            reservations = [
              {
                hostname = "timber";
                hw-address = "9c:6b:00:06:29:ef";
                ip-address = "192.168.69.7";
              }
              {
                hostname = "driftwood";
                hw-address = "d0:53:49:f3:f7:12";
                ip-address = "192.168.69.5";
              }
              {
                hostname = "ZyXEL NWA50AX";
                hw-address = "b8:ec:a3:e1:f9:e6";
                ip-address = "192.168.69.100";
              }
            ];
          }
        ];
      };
    };

    netdata = {
      enable = true;
      config = {
        web = {
          "bind to" = "127.0.0.1:19999";
        };
      };
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
      '';
    };
    
    zfs.autoScrub.enable = true;
  };
}
