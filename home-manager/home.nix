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
        source ~/.scripts/yubikey

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
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # BitWarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
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

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    cargo
    chezmoi
    coreutils
    unstable.go
    unstable.nodejs_22
    yubico-piv-tool
    ripgrep
  ];

  home.sessionVariables = {
    YUBICO_PATH = "${pkgs.yubico-piv-tool}/lib";
  };

  # home.activation.chezmoi = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #    echo -e "\033[0;34mActivating chezmoi"
  #    echo -e "\033[0;34m=================="
  #    ${pkgs.chezmoi}/bin/chezmoi apply --verbose
  #    echo -e "\033[0;34m=================="
  #  '';


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
