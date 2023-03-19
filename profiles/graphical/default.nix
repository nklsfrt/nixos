{
  abilities,
  users,
  ...
}: {
  imports = with abilities; [
    gnome
    audio
    fonts
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
}
