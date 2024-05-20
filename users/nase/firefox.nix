{ pkgs, ... }:
let
  profilePath = "plktvsa.nase";
in
{
  programs.firefox = with pkgs; {
    enable = true;
    package = wrapFirefox firefox-unwrapped {
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
      path = profilePath;
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
    directories = [ ".mozilla/firefox/${profilePath}" ];
  };
}
