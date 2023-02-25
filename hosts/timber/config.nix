{ config, abilities, pkgs, inputs, ... }:

{
  imports = with inputs; [
    ../../user-profiles/nase/home.nix
    ../../user-profiles/nase/impermanence.nix
    abilities.gnome
    impermanence.nixosModules.impermanence
  ];
  
  ## Configure the boot process

  boot = {

    loader.systemd-boot.configurationLimit = 3;

    # Load nvidia kernel modules in initramfs to avoid graphic issues in userland.
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Enable nvidia-drm via kernel parameter for wayland compatibility.
    kernelParams = [ "nvidia-drm.modeset=1" ];

    supportedFilesystems = [ "ntfs" ];

  };

  zramSwap.enable = true;

  system.autoUpgrade.persistent = true;

  # Ensure /persist is being mounted early.

  fileSystems."/persist".neededForBoot = true;

  ## Enable the X11 windowing system.

  services.xserver.videoDrivers =  [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;
  environment.systemPackages = with pkgs; [ nvidia-vaapi-driver ];

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "abfd31bd471dbd23" ];
  };

  ## Enable Pipewire for working audio

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    config.pipewire = {
      context.properties.default.clock.allowed-rates = [ 41000 48000 ];
    };
  	enable = true;
  	alsa.enable = true;
  	pulse.enable = true;
  };

  programs.fuse.userAllowOther = true;
  
  # Set the root password
  users.users.root.hashedPassword = "$6$GKt/5QJ1wA0.E/Zw$g5oPpo42B1KOm547s2wvEwpw8Us7bP4FvfPkZPKx3jKaAP57Sis/MzxgBXmvZ2WyTCInIEsF2cQG1SE3jiYMg0";

  # Specify installed system fonts
  fonts.fonts = with pkgs; [
    iosevka-bin
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

