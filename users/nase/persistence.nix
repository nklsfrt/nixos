{ ... }:
{
  home.persistence."/persist/home/niklas" = {
    directories = [
      ".ssh"
      ".gnupg"
      "codeberg"
      ".local/share/keyrings"
      ".config/evolution"
      ".config/gsconnect"
      ".config/Signal"
      ".config/VSCodium"
      ".local/share/fractal"
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
