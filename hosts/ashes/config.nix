{
  inputs,
  pkgs,
  ...
}: {
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      devices = ["/dev/sda"];
      configurationLimit = 16;
    };
  };

  networking = {
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a01:4f8:1c1c:4bd6::1";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = [
      "2a01:4ff:ff00::add:1"
      "2a01:4ff:ff00::add:2"
    ];
    firewall = {
      enable = true;
      interfaces = {
        "ens3".allowedTCPPorts = [80 443 3306];
        "ens3".allowedUDPPorts = [443];
      };
    };
  };

  services.caddy = let
    webroot = inputs.website.outPath;
  in {
    enable = true;
    adapter = "caddyfile";
    configFile = builtins.toFile "Caddyfile" ''
      nklsfrt.de {
        header Strict-Transport-Security max-age=31536000
        encode zstd gzip
        root * ${webroot}
        file_server
      }

      www.nklsfrt.de {
        redir https://nklsfrt.de/
      }

      sync.nklsfrt.de {
        reverse_proxy http://localhost:8384 {
          header_up Host {upstream_hostport}
        }
      }
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {bind-address = "78.47.95.229";};
    };
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };
}
