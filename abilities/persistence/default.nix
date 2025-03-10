{ ... }:
{
  programs.fuse.userAllowOther = true;

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/persist/home/nase".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
    directories = [
      "/etc/NetworkManager/system-connections/"
      "/var/lib/nixos"
    ];
  };
}
