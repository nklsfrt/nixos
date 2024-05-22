# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "apps/seahorse" = {
      server-publish-to = "hkps://keys.openpgp.org";
    };

    "dev/alextren/Spot" = {
      audio-backend = "pulseaudio";
      player-bitrate = "320";
    };

    "org/gnome/desktop/background" = {
      picture-uri-dark = "file:///home/niklas/.background-image";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "de"
        ])
      ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Adwaita";
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

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = mkUint32 3200;
      night-light-schedule-automatic = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
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
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "codium.desktop"
      ];
      enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
      welcome-dialog-last-shown-version = "43.1";
    };

    "org/gnome/shell/extensions/gsconnect/device/fe3f838b7341e437" = {
      paired = true;
      certificate-pem = ''
        -----BEGIN CERTIFICATE-----
        MIIC9zCCAd+gAwIBAgIBATANBgkqhkiG9w0BAQsFADA/MRkwFwYDVQQDDBBmZTNm
        ODM4YjczNDFlNDM3MRQwEgYDVQQLDAtLREUgQ29ubmVjdDEMMAoGA1UECgwDS0RF
        MB4XDTIyMDQwMTIyMDAwMFoXDTMyMDQwMTIyMDAwMFowPzEZMBcGA1UEAwwQZmUz
        ZjgzOGI3MzQxZTQzNzEUMBIGA1UECwwLS0RFIENvbm5lY3QxDDAKBgNVBAoMA0tE
        RTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOod3CIJxoFewYZ4PCv2
        3BLo3n0fvMy0MpM7npZvD5YyNdAx2EseqNcuHKNi/dDWWIaWO0qVIlaTnviHyR8a
        LZLP9d9Q2QVCb7uu2isRcNlIW0y6Vv+yKruCrvVjXzCsDnsiFgTcSZV2RWFUtbi8
        4SkCrKqkTM/1ejcV0PDK7rG1IX6wsWCTY+qELwWy2GUYqDWb3pDvzCJJ/owgCNnS
        Z/A/7MuvexOsn+iaHRO4z6zFNKpPLQjHRdnbynNfGYdI53mZTDZx43mctOoKk94N
        Atq4Ra9Z8Zla4CnNwVgbJk+Vg47rxeF90mUpjX/wO2inEel2NkSq8cCKIEX+CWQd
        K10CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAbxf6AnytAdHEs9KSUe4CUGXrTagW
        OGvIzMm8LyTsWtA0O+6b1pBEpv8wBnkVCqz9784f2GUgT6AIqSqZdewjPTiuh6k/
        rCAr5UR1tepRBHNdlYbOhBW7PqTBb20R2Ev5MbowGWI6BgMrovFSKHwZHzCk6hTa
        1SZkmYF4gSQt0pm8Kv1U7JrxTVBiHyhqsW9Ks1tBYT1YU5jLHvwOTcbQj5TN8+9d
        tdFSQX2kMmORRLC42b2hM45yR1yeiPgkh9uMjiWH6rFgEqLetKdd+ti57OU8R6VO
        wZ1nmclJ/AC7AnRjFTfZqUXjw2VOwpKn8i4pRCwzeRh2cclYl6iOA6tHNg==
        -----END CERTIFICATE-----
      '';
    };

    "org/gnome/simple-scan" = {
      document-type = "photo";
      paper-height = 2970;
      paper-width = 2100;
    };
  };
}
