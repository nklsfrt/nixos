# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "apps/seahorse" = {
      server-publish-to = "hkps://keys.openpgp.org";
    };

    "dev/alextren/Spot" = {
      audio-backend = "pulseaudio";
      player-bitrate = "320";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "de"])];
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Adwaita-dark";
      monospace-font-name = "Iosevka Term 10";
    };

    "org/gnome/desktop/privacy" = {
      disable-camera = true;
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:close";
    };

    "org/gnome/evolution/calendar" = {
      allow-direct-summary-edit = false;
      confirm-purge = true;
      time-divisions = 30;
      use-24hour-format = true;
      week-start-day-name = "monday";
      work-day-friday = true;
      work-day-monday = true;
      work-day-saturday = false;
      work-day-sunday = false;
      work-day-thursday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
    };

    "org/gnome/evolution/mail" = {
      browser-close-on-reply-policy = "ask";
      forward-style-name = "attached";
      image-loading-policy = "never";
      prompt-check-if-default-mailer = false;
      reply-style-name = "quoted";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "footclient";
      name = "Launch Terminal";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop" "codium.desktop"];
      welcome-dialog-last-shown-version = "43.1";
    };

    "org/gnome/simple-scan" = {
      document-type = "photo";
      paper-height = 2970;
      paper-width = 2100;
    };
  };
}
