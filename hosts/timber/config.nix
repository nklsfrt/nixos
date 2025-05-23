{ lib, profiles, ... }:
{
  imports = [
    profiles.graphical
    # abilities.virtualization
  ];

  networking.hostId = "c463cfe4";

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
