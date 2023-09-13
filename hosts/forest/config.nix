{
  lib,
  pkgs,
  config,
  abilities,
  ...
}: let
  wan-nic = "enp3s0";
  lan-nics = ["enp4s0" "enp5s0" "enp6s0"];
  lan-bridge = "br0";
  router-ip = "192.168.69.1";
  wan-ports = [9993];
in {
  imports = [abilities.persistence];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["rpool"];
  networking.hostId = "10fa8e3e";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.polkit.enable = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/nixos/root@blank
  '';

  boot = {
    kernel = {
      sysctl = {
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
      internalInterfaces = ["${lan-bridge}"];
      externalInterface = wan-nic;
    };
    bridges = {
      "${lan-bridge}" = {
        interfaces = lan-nics;
      };
    };
    interfaces = {
      "${lan-bridge}" = {
        ipv4.addresses = [
          {
            address = "${router-ip}";
            prefixLength = 24;
          }
        ];
      };
      "${wan-nic}" = {
        useDHCP = true;
      };
    };
    firewall = {
      trustedInterfaces = ["${lan-bridge}"];
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
      "rpool/nixos/persist".useTemplate = ["default"];
      "rpool/storage/docker-volumes".useTemplate = ["default"];
    };
  };

  services.openssh.listenAddresses = [{addr = "${router-ip}";}];

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      bind_host = "127.0.0.1"; # "disable" the web interface
      dns = {
        bind_hosts = ["${router-ip}"];
        bind_port = "53";
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
        ];
        rewrites = [
          {
            domain = "*.lan";
            answer = "${router-ip}";
          }
        ];
        enable_dnssec = true;
      };
    };
  };

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      multi-threading = {
        enable-multi-threading = true;
        thread-pool-size = 4;
        packet-queue-size = 16;
      };
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
      interfaces-config.interfaces = ["${lan-bridge}"];
      subnet4 = [
        {
          subnet = "192.168.69.0/24";
          pools = [
            {
              pool = "192.168.69.101 - 192.168.69.254";
            }
          ];
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
              hostname = "Redmi-Note-8T";
              hw-address = "90:78:b2:a7:88:73";
              ip-address = "192.168.69.10";
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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      firefly-iii-env = {};
      firefly-iii_db-env = {};
      firefly-iii_imp-env = {};
      your-spotify-server-env = {};
    };
  };

  system.activationScripts.mkTraefik = let
    docker = config.virtualisation.oci-containers.backend;
    dockerBin = "${pkgs.${docker}}/bin/${docker}";
  in ''
    ${dockerBin} network inspect traefik >/dev/null 2>&1 || ${dockerBin} network create traefik --subnet 172.20.0.0/16
  '';

  services.zerotierone = {
    enable = true;
    joinNetworks = ["abfd31bd471dbd23"];
  };

  services.factorio = {
    enable = true;
    bind = "10.147.17.30";
    openFirewall = true;
    lan = true;
    saveName = "pixelbude";
    game-name = "Pixelbude";
    description = "dreh' mal ein'!";
    admins = ["znapop" "_koon" "TingelTangel"];
  };

  virtualisation = {
    docker.extraOptions = "--ip ${router-ip} --dns ${router-ip}";
    oci-containers = {
      backend = "docker";
      containers = let
        stdOptions = {
          name,
          domain,
          port ? "8080",
          proto ? "http",
          entry ? "web",
        }: [
          "--label=traefik.enable=true"
          "--label=traefik.${proto}.routers.${name}.entrypoints=${entry}"
          "--label=traefik.${proto}.routers.${name}.rule=Host(`${domain}.lan`)"
          "--label=traefik.${proto}.services.${name}.loadbalancer.server.port=${port}"
          "--network=traefik"
        ];
      in {
        reverse_proxy = {
          image = "traefik:v2.9.8";
          ports = ["${router-ip}:80:80" "${router-ip}:25565:25565" "10.147.17.30:25565:25565"];
          extraOptions =
            stdOptions {
              name = "traefik";
              domain = "hub";
            }
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
          volumes = ["syncthing_data:/var/syncthing"];
          extraOptions = stdOptions {
            name = "syncthing";
            domain = "sync";
            port = "8384";
          };
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
          extraOptions = stdOptions {
            name = "dashdot";
            domain = "mon";
            port = "3001";
          };
        };
        firefly-iii = {
          image = "fireflyiii/core";
          ports = ["8080"];
          volumes = [
            "firefly-iii_upload:/var/html/storage/upload"
          ];
          extraOptions = stdOptions {
            name = "firefly";
            domain = "ff";
          };
          environmentFiles = [
            "/run/secrets/firefly-iii-env"
          ];
        };
        firefly-iii_db = {
          image = "mariadb";
          volumes = [
            "firefly-iii_db:/var/lib/mysql"
          ];
          environmentFiles = [
            "/run/secrets/firefly-iii_db-env"
          ];
          extraOptions = [
            "--network=traefik"
          ];
        };
        firefly-iii_importer = {
          image = "benkl/firefly-iii-fints-importer";
          volumes = [
            "firefly-iii-importer_configs:/app/configurations"
          ];
          extraOptions = stdOptions {
            name = "firefly-imp";
            domain = "ff-imp";
          };
        };
        your-spotify-server = {
          image = "yooooomi/your_spotify_server";
          environmentFiles = ["/run/secrets/your-spotify-server-env"];
          environment = {
            API_ENDPOINT = "http://your-spotify-server:8080";
            CLIENT_ENDPOINT = "http://your-spotify-client:3000";
            MONGO_ENDPOINT = "mongodb://your-spotify-server_db:27017/your_spotify";
          };
          extraOptions = stdOptions {
            name = "your_spotify";
            domain = "spot";
          };
        };
        your-spotify-server_db = {
          image = "mongo:4";
          volumes = [
            "your-spotify-server_db:/data/db"
          ];
          extraOptions = ["--network=traefik"];
        };
        your-spotify-client = {
          image = "yooooomi/your_spotify_client";
          environment = {
            API_ENDPOINT = "http://spot.lan:8080";
          };
          extraOptions =
            stdOptions {
              name = "spott";
              domain = "spott";
              port = "3000";
            }
            ++ ["--network=traefik"];
        };
        minecraft-litv3 = {
          autoStart = false;
          image = "itzg/minecraft-server";
          volumes = [
            "minecraft-litv3_data:/data"
            "minecraft-litv3_mods:/mods"
          ];
          environment = {
            EULA = "true";
            TYPE = "AUTO_CURSEFORGE";
            ONLINE_MODE = "false";
            CF_SLUG = "life-in-the-village-3";
            CF_API_KEY = "$$2a$$10$$XLOLJAY35fUGwNg2Jo0Yeu0sze/zTwuSrZxlOcFWh.1ioi6mDfAsO";
            ALLOW_FLIGHT = "true";
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
        # minecraft-atm8 = {
        #   autoStart = false;
        #   image = "itzg/minecraft-server";
        #   volumes = [
        #     "minecraft-atm8_data:/data"
        #     "minecraft-atm8_mods:/mods"
        #   ];
        #   environment = {
        #     EULA = "true";
        #     TYPE = "AUTO_CURSEFORGE";
        #     ONLINE_MODE = "false";
        #     CF_SLUG = "all-the-mods-8";
        #     ALLOW_FLIGHT = "true";
        #     MOTD = "Achja?! Komma her!";
        #     INIT_MEMORY = "6G";
        #     MAX_MEMORY = "18G";
        #   };
        #   extraOptions = [
        #     "--label=traefik.enable=true"
        #     "--label=traefik.tcp.routers.minecraft-atm8.entrypoints=mc-tcp"
        #     "--label=traefik.tcp.routers.minecraft-atm8.rule=HostSNI(`*`)"
        #     "--label=traefik.tcp.services.minecraft-atm8.loadbalancer.server.port=25565"
        #   ];
        # };
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/zerotier-one/"
    ];
  };
}
