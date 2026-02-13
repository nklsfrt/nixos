{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          mountpoint = "none";
          compression = "on";
          acltype = "posixacl";
          xattr = "sa";
        };
        options.ashift = "12";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/system/root@blank$' || zfs snapshot zroot/system/root@blank;";
        datasets = {
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "system/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
          "system/root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
        };
      };
    };

  };
}
