{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    ./yubikey.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
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

      trusted-users = ["root" "amantha"];

      substituters = [
        "https://devenv.cachix.org"
        "https://alexymantha.cachix.org"
      ];

      trusted-public-keys = [
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
  boot.kernelPackages = pkgs.unstable.linuxKernel.packages.linux_6_14;

  networking = {
    # Disable DHCP because we want to force a static IP on the management network
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [
      "192.168.2.1"
    ];
    defaultGateway = "192.168.2.1";
    vlans.management = {
      id = 20;
      interface = "enp16s0";
    };
    interfaces.management.ipv4.addresses = [
      {
        address = "192.168.2.9";
        prefixLength = 24;
      }
    ];
    # interfaces.enp16s0 = {
    #   ipv4.addresses = [ {
    #     address = "192.168.2.9";
    #     prefixLength = 24;
    #   } ];
    # };
    hostName = "amantha-nixos";
    networkmanager.enable = false; # Easiest to use and most distros use this by default.
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # services.idle-inhibitor.enable = true;

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

  programs.fish.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.amantha = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBBuACml/oi+pUzaNFQeOW+8+wWegqljXARwKFpGwnjHj3Q/YIraseXnVsSyEZ8VMR2OGyVA2pAFIIs54j5kHSWzOKbQBEF2PdEob/n6igHaLu2Df88KNar7s1HbZD6wStg== Public key for PIV Authentication" # Yubikey 5c nano
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBPdrGKtUJmJrp9Qbb17e79Vxh0Rq2DneIr2mB23KDpfZobVaa5xazVz7fD82c1egczAcVKl8BD3ap0AiHcKG+o9AXFTmQVWnv5neH5rNUVRB0PdKVRPS6p+9gj1Svyvskg== Public key for PIV Authentication" # Yubikey 5c nfc
    ];

    packages = with pkgs; [
      firefox
      tree
      kdePackages.dolphin
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default
    cachix
    fzf
    git
    gnumake
    python3
    unzip
    usbutils
    vesktop
    yq
    # Wayland stuff
    (catppuccin-sddm.override {
      flavor = "macchiato";
      font = "JetBrainsMono Nerd Font";
      fontSize = "12";
      loginBackground = true;
    })
    cloudflare-warp
    grim
    slurp
    wl-clipboard
  ];

  systemd.packages = [pkgs.cloudflare-warp]; # for warp-cli
  systemd.targets.multi-user.wants = ["warp-svc.service"];

  services.tailscale.enable = true;
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

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;
  hardware.keyboard.qmk.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  hardware.opengl = {
    enable = true;
    
    # Use the latest AMD drivers
    extraPackages = with pkgs; [
      unstable.amdvlk
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
