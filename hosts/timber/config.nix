{ lib, pkgs, profiles, ... }:
{
  imports = [
    profiles.graphical
    # abilities.virtualization
  ];

  networking.hostId = "c463cfe4";

  networking.networkmanager = {
    connectionConfig = {
      "ipv6.ip6-privacy" = 2;
      "ipv6.addr-gen-mode" = "stable-privacy";
    };
    ensureProfiles.profiles = {
      NervHQ = {
        connection = {
          autoconnect = "false";
          id = "NervHQ";
          interface-name = "wlp6s0";
          permissions = "user:nase:;";
          type = "wifi";
          uuid = "24cb7952-c07e-4998-9ec2-3c410ebd4901";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = "NervHQ";
        };
        wifi-security = {
          key-mgmt = "sae";
          psk-flags = "1";
        };
      };
      "interference" = {
        connection = {
          id = "interference";
          interface-name = "wlp6s0";
          llmnr = "0";
          mdns = "2";
          permissions = "user:nase:;";
          type = "wifi";
          uuid = "45f28e87-647e-4c34-ae85-69dfd36d99e1";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
        wifi = {
          mode = "infrastructure";
          ssid = "i n t e r f e r e n c e";
        };
        wifi-security = {
          key-mgmt = "sae";
          psk-flags = "1";
        };
      };
    };
  };

  boot = {
    initrd = {
      kernelModules = [ "amdgpu" ];
      postResumeCommands = lib.mkAfter ''
        zfs rollback -r zroot/system/root@blank
      '';
    };
    kernelParams = [ "amd_pstate=active" ];
    supportedFilesystems = [ "ntfs" ];
  };

  services.avahi = {
    openFirewall = true;
    nssmdns4 = false;
    nssmdns6 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };

  environment.systemPackages = 
    let
      alpaca-rocm = pkgs.alpaca.override {
        ollama = pkgs.ollama-rocm;
      };
    in [ alpaca-rocm ];

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;

  boot.kernelModules = [ "nct6775" ];
  programs.coolercontrol.enable = true;
  environment.persistence."/persist".directories = [ "/etc/coolercontrol" ];

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  services.pipewire.extraConfig.pipewire = {
    "10-clock-rate" = {
      "context.properties" = {
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
    };
  };
}
