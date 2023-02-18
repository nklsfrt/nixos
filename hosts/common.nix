{ pkgs, ... }:{

	imports = [ ../users/nase ];

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

	# Enable misc. services
  services.openssh.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
}
