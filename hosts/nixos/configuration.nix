# Thi:wa is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  agenix,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./home.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "vmware-workstation"
        "cloudflare-warp"
      ];
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;

      trusted-users = [ "root" "amantha" ];

      substituters = [
        "https://hyprland.cachix.org"
        "https://devenv.cachix.org"
        "https://alexymantha.cachix.org"
      ];
      
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "alexymantha.cachix.org-1:yUrFTN9X9HjjMhMrHSV+iDY0r+ZRdVUPisI6Io4PrOc="
      ];
    };
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "amantha-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Montreal";

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-macchiato";
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.amantha = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      firefox
      tree
      dolphin
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    clang
    cachix
    vesktop
    git
    usbutils
    fzf
    jq
    yq
    unzip
    python3
    # Wayland stuff
    (catppuccin-sddm.override {
      flavor = "macchiato";
      font = "JetBrainsMono Nerd Font";
      fontSize = "12";
      loginBackground = true;
    })
    wl-clipboard
    slurp
    grim
    cloudflare-warp
    agenix.packages.${system}.default
  ];

  systemd.packages = [pkgs.cloudflare-warp]; # for warp-cli
  systemd.targets.multi-user.wants = ["warp-svc.service"];

  # TODO: Remove this after IFT-3201
  virtualisation.vmware.host.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.seatd.enable = true;
  services.pcscd.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    sddm.u2fAuth = true;
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    hyprlock.u2fAuth = true;
  };

  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_BUS}=="usb",\
     ENV{ID_MODEL_ID}=="0407",\
     ENV{ID_VENDOR_ID}=="1050",\
     ENV{ID_VENDOR}=="Yubico",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  programs.hyprland = {
    enable = true;
    # Use flake when it is fixed upstream.
    #    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
