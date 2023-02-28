{
  config,
  abilities,
  profiles,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../users/nase/impermanence.nix
    profiles.desktop
  ];

  boot = {
    loader.systemd-boot.configurationLimit = 3;
    initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    kernelParams = ["nvidia-drm.modeset=1"];
    supportedFilesystems = ["ntfs"];
  };

  fileSystems."/persist".neededForBoot = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;
  environment.systemPackages = with pkgs; [nvidia-vaapi-driver];

  services.zerotierone = {
    enable = true;
    joinNetworks = ["abfd31bd471dbd23"];
  };

  services.pipewire = {
    config.pipewire = {
      context.properties.default.clock.allowed-rates = [41000 48000];
    };
  };

  programs.fuse.userAllowOther = true;

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
      "/var/lib/zerotier-one/"
    ];
  };
}
