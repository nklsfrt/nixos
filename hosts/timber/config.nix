{ config, pkgs, lib, inputs, ... }:

{
  imports = with inputs; [
    ../../users/nase/home.nix
    ../../users/nase/impermanence.nix
    impermanence.nixosModules.impermanence
  ];
  
  ## Configure the boot process

  boot = {

    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot = {
        enable = true;
        # Don't keep more than 3 previous configurations as boot entries.
        configurationLimit = 3;
      };
      # Configure efi mountpoint.
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = false;
      };
    };

    # Load nvidia kernel modules in initramfs to avoid graphic issues in userland.
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Enable nvidia-drm via kernel parameter for wayland compatibility.
    kernelParams = [ "nvidia-drm.modeset=1" ];

    # Use the latest kernel package compatible with zfs.
    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = [ "ntfs" ];

  };

  zramSwap.enable = true;

  system.autoUpgrade.persistent = true;

  # Ensure /persist is being mounted early.

  fileSystems."/persist".neededForBoot = true;

  ## Enable the X11 windowing system.

  services.xserver = {
    enable = true;
    layout = "de";
    videoDrivers =  [ "nvidia" ];
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager = {
      gnome.enable = true;
      wallpaper = {
        mode = "fill";
        combineScreens = false;
      };
    };
  };

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = true;

  # Disable unwanted services
  services.gnome = {
    core-os-services.enable = true;
    core-shell.enable = true;
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    core-utilities.enable = false;
    core-developer-tools.enable = false;
    games.enable = false;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  programs.dconf.enable = true;

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

  environment.systemPackages = with pkgs; [ nvidia-vaapi-driver ];
  
  # Set the root password
  users.users.root.hashedPassword = "$6$GKt/5QJ1wA0.E/Zw$g5oPpo42B1KOm547s2wvEwpw8Us7bP4FvfPkZPKx3jKaAP57Sis/MzxgBXmvZ2WyTCInIEsF2cQG1SE3jiYMg0";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Specify installed system fonts
  fonts.fonts = with pkgs; [
    iosevka-bin
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections/"
      "/etc/wireguard/"
    ];
  };

}
