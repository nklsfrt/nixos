{ pkgs, ... }:{

  system.stateVersion = "22.05";

	console.keyMap = "de";

	system.autoUpgrade = {
		enable = true;
		dates = "daily";
		flake = "git+https://codeberg.org/nklsfrt/nixos";
	};

	nix.settings = {
		experimental-features = [ "nix-command flakes repl-flake" ];
		auto-optimise-store = true;
		trusted-users = [ "nase" ];
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

	i18n = {
		defaultLocale = "en_US.UTF-8";
		supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
	};

	users.users.nase = {
		name = "nase";
		home = "/home/niklas";
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

	# Enable misc. services
  services.openssh.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
}
