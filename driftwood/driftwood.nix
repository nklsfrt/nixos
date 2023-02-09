{ config, pkgs, inputs, ... }:

{
  imports = with inputs; [
    ./hardware.nix
    home-manager.nixosModules.home-manager
  ];

  home-manager.users.nase = {
    imports = [ ./home/home.nix ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth.enable = true;
  networking.hostName = "driftwood";

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.opengl = {
  	enable = true;
  	extraPackages = with pkgs; [
  	  intel-media-driver
  	  vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
  	];
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  users.users.nase = {
    isNormalUser = true;
    description = "Niklas Furtwängler";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [  
      mullvad-vpn
      clapper
    ];
  };
  
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    iosevka-bin
  ];

  system.stateVersion = "22.05"; # Did you read the comment?
  system.autoUpgrade.persistent = true;
}
