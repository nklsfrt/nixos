{ lib, pkgs, ... }:{

  users.users.nase = {
    name = "nase";
    home = "/home/niklas";
    description = "Niklas Furtwängler";
    extraGroups = [ "wheel" ];
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
      exa
      bat
      fish
    ];
  };
  programs.fish.enable = true;
}