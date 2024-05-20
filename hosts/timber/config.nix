{ profiles, ... }:
{
  imports = [ profiles.graphical ];

  boot = {
    initrd.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "amdgpu"
    ];
    kernelParams = [
      "vfio-pci.ids=1002:731f,1002:ab38"
      "amd_pstate=active"
    ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.enable = true;

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
          41000
          48000
        ];
      };
    };
  };
}
