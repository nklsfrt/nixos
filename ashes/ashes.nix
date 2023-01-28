{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];

  ## Boot configuration	
  boot.loader.grub = {
    devices = [ "/dev/sda" ];
    configurationLimit = 16;
  };

  # Add authorized SSH key to user
  users.users.nase.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvAJm/S7F8FJj5veaT1lqN+3+/etph6BriSxYPzzQAe nase@timber" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuhR19nZctqp3nUHjo8cKppnHbrKjePtNL3VzT8lFlg nase@timber nixos" ];

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
        "ens3".allowedTCPPorts = [ 80 443 ];
        "ens3".allowedUDPPorts = [ 443 ];
      };
    };
  };
    # test configuration for Caddy

  services.caddy = {
    enable = true;
    configFile = builtins.toFile "Caddyfile" ''
    nklsfrt.de {
      header Strict-Transport-Security max-age=31536000
      encode zstd gzip
      root * /var/www
      file_server
    }

    www.nklsfrt.de {
      redir https://nklsfrt.de/
    }

    proof.nklsfrt.de {
      root * /var/www
      file_server {
        index proof.asc
      }
    }
    '';
  };
}
