{pkgs, ...}: let
  profileName = "plktvsa.nase";
in {
  programs.firefox = with pkgs; {
    enable = true;
    package = wrapFirefox firefox-esr-115-unwrapped {
      nixExtensions = [
        # generate hashes with 'cat FILENAME | openssl dgst -sha256 -binary | openssl base64 -A'
        (fetchFirefoxAddon {
          name = "bitwarden";
          url = "https://addons.mozilla.org/firefox/downloads/file/4140393/bitwarden_password_manager-2023.7.1.xpi";
          hash = "sha256-ozlx2A9VInn5ZXl4aTiujojEuVwp+DOcQvXeR/FSAK0=";
        })
        (fetchFirefoxAddon {
          name = "ublock";
          url = "https://addons.mozilla.org/firefox/downloads/file/4141256/ublock_origin-1.51.0.xpi";
          hash = "sha256-i3NGi8IzoR3SiVIZRmOBeD0ZEjhX3Qtv0WoBgg/KSDQ=";
        })
        (fetchFirefoxAddon {
          name = "sponsorblock";
          url = "https://addons.mozilla.org/firefox/downloads/file/4163966/sponsorblock-5.4.19.xpi";
          hash = "sha256-laP2rXUToeK1GvMT7OSl4t1oXYph43kpHEboOe4Fn3A=";
        })
        (fetchFirefoxAddon {
          name = "clearurls";
          url = "https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi";
          hash = "sha256-4gFo1jyxuLo60N5M20LFQNmf4AqpZ5tZ9JvMw28QYpE";
        })
        (fetchFirefoxAddon {
          name = "localcdn";
          url = "https://addons.mozilla.org/firefox/downloads/file/4085331/localcdn_fork_of_decentraleyes-2.6.48.xpi";
          hash = "sha256-HtqXOTPwLuYTi8BuHHCUWMD9l+Gc5jCAENp+K+B2eu0=";
        })
        (fetchFirefoxAddon {
          name = "javascript-restrictor";
          url = "https://addons.mozilla.org/firefox/downloads/file/4161098/javascript_restrictor-0.14.xpi";
          hash = "sha256-Q+50xb5hLozrbyLwuwYFRpKRVcRRSaZRYA+h4xPGMaY=";
        })
      ];
      extraPolicies = {
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DisableTelemetry = true;
        EnableTrackingProtection = {
          Value = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        EncryptedMediaExtensions.Enabled = true;
        FirefoxHome = {
          Pocket = false;
          SponsoredTopSites = false;
          SponsoredPocket = false;
          Highlights = false;
          Snippets = false;
        };
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        PictureInPicture.Enabled = false;
        UserMessaging = {
          ExtensionRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
          WhatsNew = false;
        };
      };
    };
    profiles.nase = {
      name = "nase";
      path = profileName;
      settings = {
        # enable resolution of .lan suffix
        "browser.fixup.domainsuffixwhitelist.lan" = true;
        # force dark mode
        "layout.css.prefers-color-scheme.content-override" = 0;
        # disable smooth scrolling
        "general.smoothScroll" = false;
        # disable privacy notice on first run
        "datareporting.policy.firstRunURL" = "";
        # various privacy and telemetry settings
        "browser.contentblocking.category" = "strict";
        # pretty self explainatory I guess
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"TabsToolbar\"],\"currentVersion\":19,\"newElementCount\":4}";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      };
    };
  };
  home.persistence."/persist/home/niklas" = {
    directories = [
      ".mozilla/firefox/${profileName}/extensions"
    ];
    files = [
      ".mozilla/firefox/${profileName}/places.sqlite"
      ".mozilla/firefox/${profileName}/cookies.sqlite"
    ];
  };
}
