{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware.nix
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
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # Ensure system can boot form zfs.
    supportedFilesystems = [ "zfs" ];

    # Ensure the right pool is imported on boot.
    zfs.extraPools = [ "vault" ];

  };

  # Ensure /home being mounted early.
  fileSystems."/home".neededForBoot = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  ## Select internationalisation properties.

  i18n = {

    defaultLocale = "en_US.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
    };

  };

  ## Enable the X11 windowing system.

  services.xserver.enable = true;
  services.xserver.videoDrivers =  [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  ## Enable the GNOME Desktop Environment.

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable unwanted services
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  ## Enable Pipewire for working audio

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
  	enable = true;
  	alsa.enable = true;
  	pulse.enable = true;
  };

  # Set special home path for this system
  users.users.nase = {
    home = "/home/niklas";
  };
  
  # Set the root password
  users.users.root.hashedPassword = "$6$GKt/5QJ1wA0.E/Zw$g5oPpo42B1KOm547s2wvEwpw8Us7bP4FvfPkZPKx3jKaAP57Sis/MzxgBXmvZ2WyTCInIEsF2cQG1SE3jiYMg0";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  ## Specify installed system packages

  environment.systemPackages = with pkgs; [
     foot
     htop
     vscode
     librewolf-wayland
     pavucontrol
     helvum
     iosevka-bin
     tdesktop
     signal-desktop
   ];

  # Misc Networking - Set hostname and hostid
  networking.hostName = "timber";
  networking.hostId = "68a8af9f";

}

