{
  abilities,
  users,
  pkgs,
  ...
}:
{
  imports = with abilities; [
    gnome
    audio
    printing
    persistence
    users.nase
  ];

  system.autoUpgrade = {
    persistent = true;
    operation = "boot";
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
  ];

  networking.networkmanager.connectionConfig = {
    "ipv6.ip6-privacy" = 2;
    "ipv6.addr-gen-mode" = "stable-privacy";
  };
}
