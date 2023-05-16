{profiles, ...}: {
  imports = [profiles.graphical];

  boot = {
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = ["ntfs"];
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = ["abfd31bd471dbd23"];
  };

  environment.etc."pipewire/pipewire.conf.d/set-sample-rates.conf".text = ''
    context.properties.default.clock.allowed-rates = [41000 48000]
  '';

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/zerotier-one/"
    ];
  };
}
