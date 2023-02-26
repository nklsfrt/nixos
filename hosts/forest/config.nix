{ lib, config, pkgs, inputs, ... }:
let
  wan-nic = "enp2s0";
  lan-nics = [ "enp3s0" "enp4s0" "enp5s0" ];
  lan-bridge = "br0";
  router-ip = "192.168.69.1";
  wan-ports = [ 9993 ];
in
{
  
  imports = with inputs; [ impermanence.nixosModules.impermanence ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "rpool" ];
  networking.hostId = "10fa8e3e";
  boot.loader.systemd-boot.enable = true;

  security.polkit.enable = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/root@blank
  '';

  boot = {
    kernel = {
      sysctl =  {
        "net.ipv4.conf.${wan-nic}.forwarding" = true;
        "net.ipv6.conf.${wan-nic}.forwarding" = true;
        "net.ipv4.conf.${lan-bridge}.forwarding" = true;
        "net.ipv6.conf.${lan-bridge}.forwarding" = true;
      };
    };
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "${lan-bridge}" ];
      externalInterface = wan-nic;
    };
    bridges = {
      "${lan-bridge}" = {
        interfaces = lan-nics;
      };
    };
    interfaces = {
      "${lan-bridge}" = {
        ipv4.addresses = [ { address = "${router-ip}"; prefixLength = 24; }];
      };
      "${wan-nic}" = {
        useDHCP = true;
      };
    };
    firewall = {
      trustedInterfaces = [ "${lan-bridge}" ];
      interfaces = {
        "${wan-nic}" = {
          allowedTCPPorts = lib.mkForce wan-ports;
          allowedUDPPorts = lib.mkForce wan-ports;
        };
      };
    };
  };

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };

  services.sanoid = {
    enable = true;
    templates.default = {
      autosnap = true;
      autoprune = true;
      monthly = 6;
      weekly = 4;
      daily = 7;
      hourly = 48;
    };
    datasets = {
      "rpool/persist".useTemplate = [ "default" ];
      "rpool/docker-volumes".useTemplate = [ "default" ];
    };
  };

  services.openssh.listenAddresses = [ { addr = "${router-ip}";} ];

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      bind_host = "127.0.0.1"; # "disable" the web interface
      dns = {
        bind_hosts = [ "${router-ip}" ];
        bind_port = "53";
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
        ];
        rewrites = [ { domain = "*.lan"; answer = "${router-ip}"; } ];
        enable_dnssec = true;
      };
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "${lan-bridge}" ];
    extraConfig = ''
    option domain-name-servers ${router-ip};
    option routers ${router-ip};
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.69.255;
    subnet 192.168.69.0 netmask 255.255.255.0 {
      range 192.168.69.10 192.168.69.99;
    }
    '';
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "abfd31bd471dbd23" ];
  };

  virtualisation = {
    docker.extraOptions = "--ip ${router-ip}";
    oci-containers = {
      backend = "docker";
      containers = 
        let
          stdOptions = { name, domain, port ? "8080", proto ? "http", entry ? "web" }:[
            "--label=traefik.enable=true"
            "--label=traefik.${proto}.routers.${name}.entrypoints=${entry}"
            "--label=traefik.${proto}.routers.${name}.rule=Host(`${domain}.lan`)"
            "--label=traefik.${proto}.services.${name}.loadbalancer.server.port=${port}"
          ];
      in
      {
        reverse_proxy = {
          image = "traefik:v2.9.8";
          ports = [ "${router-ip}:80:80" "${router-ip}:25565:25565" "10.147.17.30:25565:25565" ];
          extraOptions = stdOptions { name = "traefik"; domain = "hub"; port = "8080"; }
          ++ ["--label=traefik.http.routers.traefik.service=api@internal"];
          cmd = [
            "--api.dashboard=true"
            "--providers.docker=true"
            "--providers.docker.exposedbydefault=false"
            "--entrypoints.web.address=:80"
            "--entrypoints.mc-tcp.address=:25565"
          ];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
            ];
        };
        syncthing = {
          image = "syncthing/syncthing";
          volumes = [ "syncthing_data:/var/syncthing" ];
          extraOptions = stdOptions { name = "syncthing"; domain = "sync"; port = "8384"; };
        };
        dashdot = {
          image = "mauricenino/dashdot";
          volumes = [
            "/etc/os-release:/mnt/host/etc/os-release:ro"
            "/proc/1/ns/net:/mnt/host/proc/1/ns/net:ro" 
          ];
          environment = {
            DASHDOT_ENABLE_CPU_TEMPS = "true";
            DASHDOT_ALWAYS_SHOW_PERCENTAGES = "true";
            DASHDOT_WIDGET_LIST = "os,cpu,ram,storage";
            DASHDOT_DISABLE_INTEGRATIONS = "true";
          };
          extraOptions = stdOptions { name = "dashdot"; domain = "mon"; port = "3001"; };
        };
        minecraft-atm8 = {
          image = "itzg/minecraft-server";
          volumes = [
            "minecraft-atm8_data:/data"
          ];
          environment = {
            EULA = "true";
            TYPE = "AUTO_CURSEFORGE";
            ONLINE_MODE = "false";
            CF_SLUG = "all-the-mods-8";
            MOTD = "Achja?! Komma her!";
            INIT_MEMORY = "6G";
            MAX_MEMORY = "18G";
          };
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.tcp.routers.minecraft-atm8.entrypoints=mc-tcp"
            "--label=traefik.tcp.routers.minecraft-atm8.rule=HostSNI(`*`)"
            "--label=traefik.tcp.services.minecraft-atm8.loadbalancer.server.port=25565"
          ];
        };
      };
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?

    environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
    directories = [
      "/var/lib/zerotier-one/"
    ];
  };


}

