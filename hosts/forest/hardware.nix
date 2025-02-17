{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "vault" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f8754946-498c-43f7-8165-00ddcd4d76b9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4DA6-39AF";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
