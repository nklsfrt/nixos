{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.znc_conf = {
    owner = "znc";
  };
  sops.secrets.tgtgbot_env = {};

  # Boot configuration	
  boot.loader.grub = {
    devices = [ "/dev/sda" ];
    configurationLimit = 16;
  };

  # Network configuration
  networking = {
    hostName = "ashes";

    ## Specify necessary routes for Hetzners IPv6 implementation
    interfaces.ens3.ipv6.addresses = [{ address = "2a01:4f8:1c1c:4bd6::1"; prefixLength = 64;}];

    ## Set the default gateway for ipv6
    defaultGateway6 = { address = "fe80::1"; interface = "ens3"; };
    nameservers = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
    ];
    firewall = {
      enable = true;
      interfaces = {
        # Open ports for HTTP/HTTPS
        "ens3".allowedTCPPorts = [ 80 443 ];
        # Open port for HTTP/3
        "ens3".allowedUDPPorts = [ 443 ];
      };
    };
  };

  services.znc = {
    enable = true;
    openFirewall = true;
    configFile = config.sops.secrets.znc_conf.path;
  };

  # Run a toogoodtoogobot for tg notifications

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      tgtgbot = {
        image = "derhenning/tgtg";
        volumes = [ "tokens:/tokens" ];
        environmentFiles = [ "${config.sops.secrets.tgtgbot_env.path}" ];
      };
    };
  };

  # Enable Caddy webserver with its webroot in my websites repo

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
      root * ${webroot}
      file_server {
        index proof.asc
      }
    }
    '';
  };
}
