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
    users.nase
  ];

  system.autoUpgrade.persistent = true;

  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };
}
