{ pkgs, ... }:
{
  home-manager.users.nase = {
    services.syncthing.enable = true;
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          spot
          helvum
          prismlauncher
          gnome-boxes
          ;
      };
      persistence."/persist/home/nase" = {
        directories = [
          ".config/libvirt"
          ".local/state/syncthing"
        ];
      };
    };
  };
}
