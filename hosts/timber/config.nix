{
  config,
  pkgs,
  profiles,
  ...
}: {
  imports = [profiles.graphical];

  boot = {
    initrd.kernelModules = ["kvmfr" "vfio" "vfio_pci" "vfio_iommu_type1" "amdgpu"];
    extraModulePackages = [config.boot.kernelPackages.kvmfr];
    kernelParams = ["kvmfr.static_size_mb=32" "vfio-pci.ids=1002:731f,1002:ab38" "amd_pstate=active"];
    supportedFilesystems = ["ntfs"];
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = ["abfd31bd471dbd23"];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.verbatimConfig = ''
      namespaces = []
      cgroup_device_acl = [
        "/dev/kvmfr0",
        "/dev/kvm",
        "/dev/null"
      ]
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="nase", GROUP="kvm", MODE="0600"
  '';

  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  environment.etc."pipewire/pipewire.conf.d/set-sample-rates.conf".text = ''
    context.properties.default.clock.allowed-rates = [41000 48000]
  '';

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/zerotier-one/"
      "/var/lib/libvirt/qemu/"
    ];
  };
}
