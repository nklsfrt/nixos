{ pkgs,... }:
{
  home-manager.users.nase = {
    services.syncthing.enable = true;
    home = {
      packages = builtins.attrValues {
        inherit (pkgs.gnome) gnome-boxes;
      };
      persistence."/persist/home/niklas" = {
        directories = [
          ".local/share/gnome-boxes"
          ".local/state/syncthing"
        ];
      };
    };
  };
}
