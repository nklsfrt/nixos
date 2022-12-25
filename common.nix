{ pkgs, ... }:{

  system.stateVersion = "22.05";

	console.keyMap = "de";

	system.autoUpgrade = {
		enable = true;
		dates = "daily";
		flake = "git+https://codeberg.org/nklsfrt/nixos";
	};
	

	## Configure nix settings and garbage collection

	nix.settings = {
		experimental-features = [ "nix-command flakes repl-flake" ];
		auto-optimise-store = true;
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

  ## User configuration

	users.users.nase = {
		name = "nase";
		home = "/home/niklas";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
		shell = pkgs.fish;
    hashedPassword = "$6$tmq77efFOO.hfxev$s/0Ob1FwKdXUGNHloQd3ozesGLxBeMNXm0LtSaoecEuKlMJUbNqYH5UvxN4oW2dPvqxhT0JtNHNwS5DPQEJFd1";
	};

  ## Common system packages

	environment.systemPackages = with pkgs; [
		git
		tmux
		micro
		exa
		bat
		fish
	];
  
	# Enable misc. services
  services.openssh.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
}
