{inputs, ...}: {
  home.persistence."/persist/home/niklas" = {
    directories = [
      ".ssh"
      ".gnupg"
      "codeberg"
      ".mozilla/firefox/vlqejqkk.niklas"
      ".local/share/keyrings"
      ".cache/spotify/Users"
      ".config/evolution"
      ".config/gsconnect"
      ".config/Signal"
      ".config/spotify"
      ".config/VSCodium"
      ".local/share/TelegramDesktop"
      ".local/share/PrismLauncher"
      ".local/state/wireplumber"
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
