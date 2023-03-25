{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        UserMessaging = {
          WhatsNew = false;
          ExtensionRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };
        OverrideFirstRunPage = "";
      };
    };
    profiles.nase = {
      name = "nase";
      path = "plktvsa.nase";
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
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        # pretty self explainatory I guess
        "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"TabsToolbar\"],\"currentVersion\":19,\"newElementCount\":4}";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      };
    };
  };
}
