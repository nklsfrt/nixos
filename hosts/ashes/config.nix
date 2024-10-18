{
  config,
  inputs,
  pkgs,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      devices = [ "/dev/sda" ];
      configurationLimit = 16;
    };
  };

  sops = {
    secrets = {
      forgejo_runner_token = { };
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
        "ens3".allowedTCPPorts = [
          80
          443
          3306
        ];
        "ens3".allowedUDPPorts = [ 443 ];
      };
    };
  };

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

        sync.nklsfrt.de {
          reverse_proxy http://localhost:8384 {
            header_up Host {upstream_hostport}
          }
        }

        kurbelerzeugnis.jetzt {
          respond "Nicht gestern, nicht morgen - jetzt!"
        }
      '';
    };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "ashes";
      url = "https://codeberg.org";
      tokenFile = config.sops.secrets.forgejo_runner_token.path;
      labels = [
        "native:host"
        "nix-container:docker://nixos/nix:latest"
      ];
      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nodejs
        wget
        nix
      ];
    };
  };
}
