{
  lib,
  pkgs,
  profiles,
  abilities,
  ...
}:
{
  imports = [
    profiles.graphical
    abilities.virtualization
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

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIBpTCCAUqgAwIBAgIRAOE56IY5hlx35SWsM+KrBSQwCgYIKoZIzj0EAwIwMDEu
      MCwGA1UEAxMlQ2FkZHkgTG9jYWwgQXV0aG9yaXR5IC0gMjAyNCBFQ0MgUm9vdDAe
      Fw0yNDA3MjIwNTU1NTNaFw0zNDA1MzEwNTU1NTNaMDAxLjAsBgNVBAMTJUNhZGR5
      IExvY2FsIEF1dGhvcml0eSAtIDIwMjQgRUNDIFJvb3QwWTATBgcqhkjOPQIBBggq
      hkjOPQMBBwNCAAQoFG7fZCe//RdxdLNXVMjktOaOfxR45Ix++hORzyULu03HcsoZ
      1j4DBWPWlpsEUlfPCzogEeqtQ7KSoAV77bNAo0UwQzAOBgNVHQ8BAf8EBAMCAQYw
      EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQUn29J/2X5xdctzZaiYlyL2/wG
      UtgwCgYIKoZIzj0EAwIDSQAwRgIhAKxq5Zr/m01f5/0dfJIs8a+mh2g3MczYssCn
      6lff9FKYAiEA8Dn0T0lxTnxhbWksaOA6W0e3oacLSmCR+6efj9R+hL4=
      -----END CERTIFICATE-----
    ''
  ];

  environment.systemPackages =
    let
      alpaca-rocm = pkgs.alpaca.override {
        ollama = pkgs.ollama-rocm;
      };
    in
    [
      alpaca-rocm
      pkgs.mbuffer
    ];

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
