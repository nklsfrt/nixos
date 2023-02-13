{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2bff79bb-135e-4f05-b401-68a89cec458f";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."vault".device = "/dev/disk/by-uuid/eea4b73a-1d5f-4688-a59b-a8d161271f50";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/2bff79bb-135e-4f05-b401-68a89cec458f";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6EBE-0A68";
      fsType = "vfat";
    };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
}
