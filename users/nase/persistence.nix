{inputs, ...}: {
  home.persistence."/persist/home/niklas" = {
    directories = [
      ".ssh"
      ".gnupg"
      "codeberg"
      ".mozilla/firefox/vlqejqkk.niklas"
      ".local/share/keyrings"
      ".config/evolution"
      ".local/share/TelegramDesktop"
      ".local/share/PrismLauncher"
      "Documents"
      "Pictures"
    ];
    files = [
      "./.background-image"
      ".config/monitors.xml"
      ".config/sops/age/keys.txt"
      ".local/share/fish/fish_history"
    ];
    allowOther = true;
  };
}
