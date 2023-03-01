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

  system.autoUpgrade.persistent = true;

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };
}
