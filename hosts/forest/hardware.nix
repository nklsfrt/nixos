{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/478bc961-5a1d-4bf5-b058-99b91cab05b5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3428-C64F";
      fsType = "vfat";
    };

  fileSystems."/var/lib/docker/volumes" =
    { device = "dev/disk/by-uuid/685719b6-6ece-4ce2-a8bd-c5d543dc1389";
      fsType = "ext4";
    };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
