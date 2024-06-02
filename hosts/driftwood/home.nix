{ ... }:
{
  home-manager.users.nase = {
    dconf.settings = {
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };
    };
  };
}
