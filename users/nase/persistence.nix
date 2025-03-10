{ ... }:
{
  home.persistence."/persist/home/nase" = {
    directories = [
      ".ssh"
      ".gnupg"
      "codeberg"
      ".local/share/keyrings"
      ".config/gsconnect"
      ".config/Signal"
      ".config/VSCodium"
      ".local/share/fractal"
      ".local/share/TelegramDesktop"
      ".local/share/PrismLauncher"
      ".local/state/wireplumber"
      ".thunderbird"
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
