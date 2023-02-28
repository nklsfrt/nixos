{
  lib,
  pkgs,
  users,
  ...
}: {
  imports = [users.nase];

  system.stateVersion = "22.05";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.efiSysMountPoint = lib.mkDefault "/boot";
    };
  };

  console.keyMap = "de";

  time.timeZone = "Europe/Berlin";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = "git+https://codeberg.org/nklsfrt/nixos";
  };

  nix.settings = {
    experimental-features = ["nix-command flakes repl-flake"];
    auto-optimise-store = true;
    trusted-users = ["nase"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8"];
  };

  # Enable misc. services
  services.openssh.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;

  zramSwap.enable = true;
}
