{ pkgs, ... }:
{
  users.users.nase.extraGroups = [ "libvirtd" ];

  boot = {
    initrd.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
    kernelParams = [ "amd_iommu=on" "vfio-pci.ids=03:00.0,03:00.1" ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            msVarsTemplate = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
    virt-manager
  ];
}
