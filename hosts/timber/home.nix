{ pkgs, ... }:
{
  home-manager.users.nase = {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          spot
          helvum
          prismlauncher
          gnome-boxes
          pipeline
          ;
      };
      persistence."/persist" = {
        directories = [
          ".config/libvirt"
        ];
      };
    };
  };
}
