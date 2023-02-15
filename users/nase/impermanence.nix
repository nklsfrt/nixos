{inputs, ...}:{

  home-manager.users.nase = {

    imports = with inputs; [
      impermanence.nixosModules.home-manager.impermanence
    ];

    home.persistence."/persist/home/niklas" = {
      directories = [
        ".ssh"
        ".gnupg"
        "codeberg"
        ".mozilla/firefox/vlqejqkk.niklas"
        ".local/share/keyrings"
        ".local/share/Steam"
        ".config/evolution"
        ".local/share/TelegramDesktop"
        ".local/share/PrismLauncher"
        "Documents"
        "Pictures"
      ];
      files = [
        "./.background-image"
        ".config/monitors.xml"
        ".local/share/fish/fish_history"
      ];
      allowOther = true;
    };
    
  };
}