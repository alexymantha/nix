{
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = null; # Installed externally, homebrew on MacOS
    profiles = {
      default = {
        id = 0;
        name = "Alexy Mantha";
        isDefault = true;
        settings = {
          # Disable about:config warning
          "browser.aboutConfig.showWarning" = false;

          # Mozilla telemetry
          "toolkit.telemetry.enabled" = true;

          # Homepage settings
          # 0 = blank, 1 = home, 2 = last visited page, 3 = resume previous session
          "browser.startup.page" = 1;
          "browser.startup.homepage" = "about:home";
          "browser.newtabpage.enabled" = true;
          "browser.newtabpage.activity-stream.topSitesRows" = 2;
          "browser.newtabpage.storageVersion" = 1;
          "browser.newtabpage.pinned" = [
            {
              "label" = "GitHub";
              "url" = "https://github.com";
            }
            {
              "label" = "YouTube";
              "url" = "https://youtube.com";
            }
          ];

          # Activity Stream
          "browser.newtab.preload" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = true;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";

          # Addon recomendations
          "browser.discovery.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # Crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "extensions.autoDisableScopes" = 0;

          # Auto-decline cookies
          "cookiebanners.service.mode" = 2;
          "cookiebanners.service.mode.privateBrowsing" = 2;

          # ECH - prevent TLS connections leaking request hostname
          "network.dns.echconfig.enabled" = true;
          "network.dns.http3_echconfig.enabled" = true;

          # Tracking
          "browser.contentblocking.category" = "strict";
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;

          # Fingerprinting
          "privacy.fingerprintingProtection" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.pbmode" = true;

          "privacy.firstparty.isolate" = true;

          # URL query tracking
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;

          # Prevent WebRTC leaking IP address
          "media.peerconnection.ice.default_address_only" = true;

          # Disable password manager
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;

          # Disable pocket
          "extensions.pocket.enabled" = false;
          # Disable FireFox Account
          "identity.fxaccounts.enabled" = false;
        };
        search = {
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["@nw"];
            };

            "Bing".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          vimium
          refined-github
        ];
      };
    };
  };
}
