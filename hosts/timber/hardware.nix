{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  boot.initrd.luks.devices."vault".device = "/dev/disk/by-uuid/a0513179-7999-4531-992a-fba79f1f9d1c";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/96784b15-65e9-49d8-9752-9af9630fb75d";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/96784b15-65e9-49d8-9752-9af9630fb75d";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd"];
  };

  fileSystems."/var/lib/libvirt/images" = {
    device = "/dev/disk/by-uuid/96784b15-65e9-49d8-9752-9af9630fb75d";
    fsType = "btrfs";
    options = ["subvol=persist/virt"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/156D-0C6C";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
