{ config, pkgs, ... }:
let
  ula-network-address = "fd5e:08d3:3e55::"; # first /64 subnet of fd5e:08d3:3e55::/48
  ula-network-size = "/64";
  router-ula-address = "${ula-network-address}1";
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
    jool = {
      enable = true;
      nat64.default = {};
    };
    firewall = {
      trustedInterfaces = [ lan-bridge ];
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
          DHCPServer = "no";
          IPv6SendRA = "yes";
          DHCPPrefixDelegation = "yes";
          MulticastDNS = "yes";
        };
        dhcpPrefixDelegationConfig = {
          UplinkInterface = "wan";
          Token = "prefixstable";
        };
        ipv6SendRAConfig = {
          EmitDNS = "yes";
          DNS = "${router-ula-address}";
        };
        ipv6Prefixes = [
          {
            Prefix = ula-network-address + ula-network-size;
            Assign = true;
            Token = "static:::1";
          }
        ];
      };
    };
  };

  services.resolved = {
    llmnr = "false";
    extraConfig = "[Resolve]\nMulticastDNS=yes";
  };

  services = {

    caddy = {
      enable = true;
      globalConfig = ''
        admin [::1]:2019
        default_bind [${router-ula-address}]
      '';
      # a hack to force automatically generated servers for http -> https redirection
      extraConfig = ''
        http:// {
        }
      '';
    };

    adguardhome = {
      enable = true;
      mutableSettings = false;
      host = "127.0.0.1";
      port = 3000;
      settings = {
        dns = {
          bind_hosts = [
            "${router-ula-address}"
          ];
          port = 53;
          upstream_dns = [
            "quic://unfiltered.adguard-dns.com"
            "quic://p0.freedns.controld.com"
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
          use_dns64 = true;
        };
        filtering.rewrites = [
          {
            domain = "*.${domain}";
            answer = "${router-ula-address}";
          }
        ];
        filters = [
          {
            enabled = true;
            url = "https://codeberg.org/hagezi/mirror2/raw/branch/main/dns-blocklists/adblock/ultimate.txt";
            name = "Hagezi Ultimate";
            id = 1337;
          }
        ];
      };
    };

    caddy.virtualHosts = {
      "agh.${domain}" = {
        extraConfig = ''
          tls internal
          reverse_proxy [::1]:${toString config.services.adguardhome.port}
        '';
      };
    };

    glances =
      let
        configFile = pkgs.writeText "glances.conf" ''
          [percpu]
          disable=False
          max_cpu_display=4
          [gpu]
          disable=True
          [ip]
          public_disabled=False
          public_api=https://ipv6.ipleak.net/json/
          public_field=ip
          public_template={continent_name}/{country_name}/{city_name}
          [connections]
          disable=True
          [irq]
          disable=True
        '';
      in
      {
        enable = true;
        extraArgs = [
          "--bind"
          "127.0.0.1"
          "--webserver"
          "--config"
          "${configFile}"
        ];
      };

    caddy.virtualHosts = {
      "mon.${domain}" = {
        extraConfig = ''
          tls internal
          reverse_proxy [::1]:${toString config.services.glances.port}
        '';
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

    caddy.virtualHosts = {
      "paper.${domain}" = {
        extraConfig = ''
          tls internal
          reverse_proxy [::1]:${toString config.services.paperless.port}
        '';
      };
    };

    firefly-iii = {
      enable = true;
      virtualHost = "ff.${domain}";
      settings = {
        APP_KEY_FILE = config.sops.secrets.firefly_admin_password.path;
        TRUSTED_PROXIES = "*";
      };
      poolConfig = {
        "listen.group" = "caddy";
      };
    };

    caddy.virtualHosts = {
      "ff.${domain}" = {
        extraConfig = ''
          tls internal
          php_fastcgi unix//${config.services.phpfpm.pools.firefly-iii.socket}
          root * ${config.services.firefly-iii.package}/public
          file_server
        '';
      };
    };

    firefly-iii-data-importer = {
      enable = true;
      settings = {
        FIREFLY_III_URL = "https://ff.${domain}";
        FIREFLY_III_ACCESS_TOKEN_FILE = config.sops.secrets.firefly_access_token.path;
      };
      poolConfig = {
        "listen.group" = "caddy";
      };
    };

    caddy.virtualHosts."ffi.${domain}".extraConfig = ''
      tls internal
      php_fastcgi unix//${config.services.phpfpm.pools.firefly-iii-data-importer.socket}
      root * ${config.services.firefly-iii-data-importer.package}/public
      file_server
    '';

    zfs.autoScrub.enable = true;
  };

  sops.secrets = {
    firefly_admin_password = {
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
    firefly_access_token = {
      owner = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
    };
    paperless_admin_password = { };
  };
}
