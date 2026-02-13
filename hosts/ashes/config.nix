{ inputs, ... }:
{
  boot.loader = {
    systemd-boot.enable = false;
  };

  networking = {
    firewall.interfaces."enp1s0" = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        80
        443
      ];
    };
    nftables.enable = true;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks."20-enp1s0" = {
      matchConfig.Name = "enp1s0";
      address = [ "2a01:4f8:1c1b:bb96::1" ];
      gateway = [ "fe80::1" ];
      dns = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
      ];
    };
  };

  services.murmur = {
    enable = true;
    openFirewall = true;
    registerName = "Dings";
    registerHostname = "talk.nklsfrt.de";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/murmur"
  ];

  services.caddy =
    let
      webroot = inputs.website.outPath;
    in
    {
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

        proof.nklsfrt.de {
          redir https://keyoxide.org/aspe:keyoxide.org:54UMIULBO36HX33OT5SO77ZF4A
        }

        hellodarkness.de {
          respond hi!
        }

        www.hellodarkness.de {
          redir https://hellodarkness.de/
        }
      '';
    };
}
