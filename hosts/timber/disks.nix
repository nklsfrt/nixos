{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/disk/by-id/ata-CT480BX500SSD1_2117E59B931D";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
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
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/system/root@blank$' || zfs snapshot zroot/system/root@blank";
        datasets = {
          "zroot" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
            postCreateHook = ''
             zfs set keylocation="prompt" "zroot/$name";
            '';
          };
          "zroot/local/nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };
          "zroot/system/persist" = {
            type = "zfs_fs";
            options.mountpoint = "/persist";
            mountpoint = "/persist";
          };
          "zroot/system/root" = {
            type = "zfs_fs";
            options.mountpoint = "/";
            mountpoint = "/";
          };
          "zroot/user/nase" = {
            type = "zfs_fs";
            options.mountpoint = "/persist/home/nase";
            mountpoint = "/persist/home/nase";
          };
        };
      };
    };
  };
}