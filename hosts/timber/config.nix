{ config, abilities, pkgs, inputs, ... }:

{
  imports = [
    ../../user-profiles/nase/home.nix
    ../../user-profiles/nase/impermanence.nix
    abilities.gnome
    abilities.pipewire
  ];

  boot = {
    loader.systemd-boot.configurationLimit = 3;
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [ "nvidia-drm.modeset=1" ];
    supportedFilesystems = [ "ntfs" ];
  };

  system.autoUpgrade.persistent = true;

  fileSystems."/persist".neededForBoot = true;

  services.xserver.videoDrivers =  [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;
  environment.systemPackages = with pkgs; [ nvidia-vaapi-driver ];

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "abfd31bd471dbd23" ];
  };

  services.pipewire = {
    config.pipewire = {
      context.properties.default.clock.allowed-rates = [ 41000 48000 ];
    };
  };

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  fonts.fonts = with pkgs; [
    fira-code
  ];

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

