{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users.users.nase = {
    name = "nase";
    home = "/home/niklas";
    description = "niklas";
    extraGroups = [
      "wheel"
      "lp"
      "scanner"
    ];
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuhR19nZctqp3nUHjo8cKppnHbrKjePtNL3VzT8lFlg nase@timber"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKE926T8orbrGuuHTs15n8ON4E5gyAv+enD8GWNWSRNW nase@driftwood"
    ];
    hashedPassword = "$6$tmq77efFOO.hfxev$s/0Ob1FwKdXUGNHloQd3ozesGLxBeMNXm0LtSaoecEuKlMJUbNqYH5UvxN4oW2dPvqxhT0JtNHNwS5DPQEJFd1";
    packages = with pkgs; [
      git
      tmux
      micro
      htop
      eza
      bat
      fzf
      fd
      fish
    ];
  };

  programs.fish.enable = true;

  system.stateVersion = "22.05";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 5;
      };
      efi.efiSysMountPoint = lib.mkDefault "/boot";
    };
  };

  hardware.enableRedistributableFirmware = true;

  console.keyMap = "de";

  time.timeZone = "Europe/Berlin";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = "git+https://codeberg.org/nklsfrt/nixos";
    flags = [ "--refresh" ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = [ "nix-command flakes" ];
      trusted-users = [ "nase" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  security.sudo.extraRules = [
    {
      users = [ "nase" ];
      runAs = "ALL:ALL";
      commands = [
        {
          command = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  sops = {
    defaultSopsFile = ../../hosts/${config.networking.hostName}/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  services.openssh.enable = true;
  programs.command-not-found.enable = false;
}
