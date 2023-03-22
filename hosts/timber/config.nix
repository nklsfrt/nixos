{
  config,
  profiles,
  pkgs,
  ...
}: {
  imports = [profiles.graphical];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    kernelParams = ["nvidia-drm.modeset=1"];
    supportedFilesystems = ["ntfs"];
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;
  environment.systemPackages = with pkgs; [nvidia-vaapi-driver];

  services.zerotierone = {
    enable = true;
    joinNetworks = ["abfd31bd471dbd23"];
  };

  services.pipewire = {
    config.pipewire = {
      context.properties.default.clock.allowed-rates = [41000 48000];
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/zerotier-one/"
    ];
  };
}
