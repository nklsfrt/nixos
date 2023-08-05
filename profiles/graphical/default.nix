{
  abilities,
  users,
  pkgs,
  ...
}: {
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

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  fonts.packages = with pkgs; [
    fira-code
  ];
}
