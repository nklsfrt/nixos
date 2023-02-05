{ config, pkgs, website, ... }:

{
  imports = [
    ./hardware.nix
  ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets."tgtg_email" = {};
  sops.secrets."tgtgbot/tg_chat_ids" = {};
  sops.secrets."tgtgbot/tg_bot_token" = {};

  # Boot configuration	
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
        # Open ports for HTTP/HTTPS
        "ens3".allowedTCPPorts = [ 80 443 ];
        # Open port for HTTP/3
        "ens3".allowedUDPPorts = [ 443 ];
      };
    };
  };

  # Run a toogoodtoogobot for tg notifications

  virtualisation.oci-containers.containers = {
    tgtgbot = {
      image = "derhenning/tgtg";
      volumes = [ "tokens:/tokens" ];
      # environmentFiles = [ /home/nase/tgtgbot.env ];
      environment = {
        TZ = "Europe/Vienna";
        DEBUG = false;
        TGTG_USERNAME = "${config.sops.secrets."tgtgbot/tgtg_email"}";
        SLEEP_TIME = 60;
        DISABLE_TESTS = true;
        quiet = false;
        TELEGRAM = true;
        TELEGRAM_TIMEOUT = 60;
        TELEGRAM_CHAT_IDS = "${config.sops.secrets."tgtgbot/tg_chat_ids"}";
        TELEGRAM_BOT_TOKEN = "${config.sops.secrets."tgtgbot/tg_bot_token"}";
      };
    };
  };

  # Enable Caddy webserver with its webroot in my websites repo

  services.caddy = 
  let
    webroot = website.outPath;
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
