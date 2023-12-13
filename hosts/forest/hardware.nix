{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.kernelModules = ["kvm-intel"];

  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "rpool/nixos/persist";
    fsType = "zfs";
  };

  fileSystems."/var/lib/docker/volumes" = {
    device = "rpool/storage/docker-volumes";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/media/library" = {
    device = "rpool/storage/library";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "rpool/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1732-7A79";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
