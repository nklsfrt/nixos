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

  fileSystems."/persist/home/nase".neededForBoot = true;

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
    corefonts
  ];
}
