{ ... }:
{
  home.persistence."/persist" = {
    directories = [
      ".ssh"
      ".gnupg"
      ".local/share/keyrings"
      ".config/gsconnect"
      ".config/Signal"
      ".local/share/com.jeffser.Alpaca"
      ".local/share/fractal"
      ".local/share/TelegramDesktop"
      ".local/share/PrismLauncher"
      ".local/state/wireplumber"
      ".thunderbird"
      "Books"
      "code"
      "Documents"
      "Music"
      "Pictures"
      "Videos"
    ];
    files = [
      "./.face"
      "./.background-image"
      ".config/goa-1.0/accounts.conf"
      ".config/monitors.xml"
      ".config/sops/age/keys.txt"
      ".local/share/fish/fish_history"
      ".local/share/gnome-shell/session-active-history.json"
    ];
  };
}
