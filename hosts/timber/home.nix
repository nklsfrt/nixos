{...}: {
  home-manager.users.nase = {
    services.syncthing.enable = true;
    home.persistence."/persist/home/niklas" = {
      directories = [
        ".local/state/syncthing"
      ];
    };
  };
}
