{ pkgs, ... }:{

  system.stateVersion = "22.05";

	## Configure nix settings and garbage collection

	nix.settings = {
		experimental-features = [ "nix-command flakes" ];
		auto-optimise-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

  ## User configuration

	users.users.nase = {
		name = "nase";
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

}