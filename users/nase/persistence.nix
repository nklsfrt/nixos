{ ... }:
{
  home.persistence."/persist/home/nase" = {
    directories = [
      ".ssh"
      ".gnupg"
      ".local/share/keyrings"
      ".config/gsconnect"
      ".config/Signal"
      ".config/VSCodium"
      ".local/share/fractal"
      ".local/share/TelegramDesktop"
      {
        directory = ".local/share/PrismLauncher";
        method = "symlink";
      }
      ".local/state/wireplumber"
      ".thunderbird"
      "code"
      "Documents"
      "Music"
      "Pictures"
      "Videos"
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
