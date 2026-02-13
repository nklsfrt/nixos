{ pkgs, ... }:
let
  profilePath = "x9wrayxc.nase";
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisablePocket = true;  # doesn't exist anymore
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
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
      OverrideFirstRunPage = "";
      PasswordManagerEnabled = false;
      PictureInPicture.Enabled = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
        WhatsNew = false;
      };
      GenerativeAI = {
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
        Enabled = false;
        Locked = true;
      };
    };
    profiles.nase = {
      name = "nase";
      path = profilePath;
      settings = {
        "browser.fixup.domainsuffixwhitelist.lan" = true;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "general.smoothScroll" = false;
        "datareporting.policy.firstRunURL" = "";
        "browser.contentblocking.category" = "strict";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "dom.private-attribution.submission.enabled" = false;
      };
      search = {
        force = true;
        default = "Fairsuch";
        engines = {
          "Fairsuch" = {
            urls = [
              {
                template = "https://fairsuch.net/search";
                method = "POST";
                params = [
                  {
                    name = "preferences";
                    value = "eJx1WMuO7DYO_ZrUxkhhkjvAYBa1CjLbCTDZG7LEsnUtib56VJX764f0o0y1-y7a3SL1oA7JQ6q1ytBjtJBuPQSIyl2cCn1RPdxUyXhxqJWDG4QLDzX6yUGG29OOdgJj1cV6mttOEV_z7T_KJbh4yAOa21___d_fl6TukEBFPdz-cckDeLgly3tcIqTicmoxtAGebVbdttygbUmJ7gHxlrT9dSjdleTrujbl2W22aQgZYquc7YOnv7cNlHmooMG028Gr9EeBOLc2tNlm2mAV2nC3wWbaVUd07vZ3LHTQsowN0ys6M-3kQOdVPWAeYU43A3dFN7gYm1Tn6DgIvQ0E5L971bdtQm2VazyD9Mvvf6gQVGp4Y_uAtr1bB4nF09h4GyNGKaN7NvRtUsYoJwelMRjVtjbzMI1tu3mNhp11ln_a9mENYFpEoa-n5K7oEfK2Qzd1lTob2_fHeYvtV6311YDYVU9ThDtEIJC3jQi9lEhI19aW5avsaR6WfCuOmGH6NGyWAEq00fJ7E1JIkIi_vFOJzkJlqRrCgHcpMgAfFAytL8nqZZyyypZ2QYq7yBLTN-Q0drjFkORiIFutEVMJJf7p8Wye0K2QCGiErrqBkD9B8SHHWau7vZpoOn3ZGo_f1-w6ZmUKrbnC4LeXMOpuIvIFdtfRLU0eVPaUcXJaBGgS3vNTRWiMjRTVHN-rF-_RhtEqLRfMs4Clp9RR3e5zNNBB7Lch6YCCBf0-RjQRlBEOIFFPV52cmjm802Gu1HikoJGgesrCyLlk9eK2t3H9hMZInw-qi4o_mw2DomCPqydWAbzeEUu7pqvFbWy96Q5Lre9LFCfZoIRBNtCfFkv6WrZb892mAY89KTujinPDHkxWXJ4VkKMKyZFN0sUOu5ThGnfziVmVnlTYh_gxWDnfP33npCBMuzvCrNRxJJo5gcxpnIAoNIOwl0URJhSWToSn6m3a-YN4YCNLceZbeE6dQ7VnzlfLqsyZiPwNPLYDI-ZMRI8UEggistaVfk62BpC4WZeUrtNMJWmHTStjZo5UX4gK9uCfqNCgg5N83ZqDveHPW-pVyFY3SdMqFSXxEe_EPHFVFJZkHGfMSBExsv92RDMjQ3uoUk0W0g2HXMXnrAZEueJpu1mOqWa_VDCRKUTOGm2HOKbPwh8Fa-BYmLBEfZZOoJf8_In4wIHFVMPTgmU9-4HzJ3x--_btX68DF1MMBOnfj6B8Fer4HWA8S85Bt8mrqFo4ZrIO83FGUA_mkmPDWLq5B78n36x0dQ8en0-LhVJQZpYjDBIljpQ98WVHDBTYTZoDhplJ-rgrjLE2dxWdzlrFpyKUvk_X6SnRI3LRWdqeHj2nttjrQeXD2VB2fmQveSqV1Y2L926uGO3gpjVahpIP_q_Se-yvPYpUptRkuocSiWgW23_59ud-iwuEuqdaiGGxr2HL9g4oUgqKS6j4sg8Zgh3lgFZ-Okj53bjWfVHoz_Au0soPi-SENxMlx7kstHqA-4hMjDtY1MRwxzTXPcvDEo3QNWR_gVy0Gup6hSuMypXFR0NRtTF59hgIJhFOd2f1KGsZTbeyTPVMqHsZpCp-HLxWZXnAVqdPUG3yCqxNdoJrk39BnMN23nL4SGarJMskeD83Oz2vXFP32OuMkiD-TEfVLP9MxzsTFGf1x69b6a5LNtdyvNOyQLmUJBrkgP5RucsrauUNhp8Y91YPKg1E_l_MMO-ib1_aYTGHA6kSjRb2noejUVFjxxGTIFeMvOuoqFJUqK0NrvVEFgCZGtG9G51MB3LSRA8grqWb1vIbDJKM4IkzTHh8GV8Xcw-rJ8sdWKcEqtTOaUKCWldu0_YAJmM9bycsmKedAX48KX8k0ougDsRVdIrZVXwKz6iojWs6ehAk2VoSoMbmk18SVRG190AHA1ObNiJxwt3h83itla6EXPaGk3EL1NCtT8Kv-ogyQSzp7Vl6EltD7Xpco3RHrQQm0jTIFxS3BzUIM5ZcOlmE3pL3i0lZR_zBUSGmPaznrvCoXcRG1c4k4CVLfuw-40mcTxRf1xPwUnmCXypVMdyfS-reVcvlDwye6O5ReeWmoaZJq_MHhorDPFVbT4-e5t1ym6pQAcRPSC3OppuN_Jp9QldV8miCHcU7DTHz44u99ilWnsq5gZqMILHIOV6tqNXEK4_6qcuCM4ir-ATfKq6LVv6neNNXZfdTqywVvPj418bkCtXhdONIf1230XUgNqW2DFpiFKfWmP1yQjppULXr_3mekVr2k5qivKUSqsd3I_C1BVo5XciFGM9nc0qsg5Mugbu3NtzxfHBcnoxtiY6M85zDpzlcflqifdJRCl-osyfWvP0fXeJJxw==";
                  }
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "np" ];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "nw" ];
          };
          "NixOS Options" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
  home.persistence."/persist" = {
    directories = [ ".config/librewolf/${profilePath}" ];
  };
}
