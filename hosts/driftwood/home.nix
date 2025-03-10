{ ... }:
{
  home-manager.users.nase = {
    services.syncthing.enable = true;
    home.persistence."/persist/home/nase".directories = [ ".local/state/syncthing" ];
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
