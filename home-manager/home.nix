# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlay
    ];
  };

  programs = {
    zsh = {
      enable = true;
      history = {
        ignoreDups = true;
        ignoreSpace = true;
        save = 50000;
        size = 50000;
      };
      initExtraFirst = ''
        ### SSH Agent
        #source ~/.scripts/yubikey

        # Move this to history.append once available in current version
        setopt APPEND_HISTORY
      '';
      initExtra = ''
        source ~/.zshrc.post
      '';
    };
    firefox = {
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
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://wiki.nixos.org/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            vimium
          ];
        };
      };
    };
    neovim.enable = true;
    home-manager.enable = true;
    git.enable = true;
    direnv.enable = true;
    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.waybar.enable = true;
  programs.wofi.enable = true;
  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      source = "~/.config/hypr/amantha.conf";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    cargo
    chezmoi
    coreutils
    unstable.go
    unstable.nodejs_22
    yubico-piv-tool
    ripgrep
    kitty
  ];

  home.sessionVariables = {
    YUBICO_PATH = "${pkgs.yubico-piv-tool}/lib";
  };

  home.file.".config/Yubico/u2f_keys".text = ''
    amantha:BoQ5kI6GuB5JPTi678Jp37AgtxstZq4jTzKHbFvYzDNH+R3IqchopN0ItO0bVbxQItaxD0p7vl7n0Op0fWjGrw==,kHhDd0dvFTpum6cTw/k/mDf5lWj8+aoz+YAKBqADGZsuYSDs6zvVRONGP2egM8b35wULUOzQvUTCMLr4pOeafQ==,es256,+presence
  '';

  #home.activation.chezmoi = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # echo -e "\033[0;34mActivating chezmoi"
   #  echo -e "\033[0;34m=================="
 #    ${pkgs.chezmoi}/bin/chezmoi apply --verbose
  #   echo -e "\033[0;34m=================="
#   '';


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
