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
      {
        directory = "code";
        method = "symlink";
      }
      {
        directory = "Documents";
        method = "symlink";
      }
      {
        directory = "Pictures";
        method = "symlink";
      }
      {
        directory = "Videos";
        method = "symlink";
      }
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
