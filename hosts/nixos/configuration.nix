{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    ./yubikey.nix
    ./kde.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      (final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs (old: rec {
          version = "20260622";
          src = prev.fetchFromGitLab {
            owner = "kernel-firmware";
            repo = "linux-firmware";
            tag = version;
            hash = "sha256-nSoJhgI4hAxtNmnj5M6ticzuBSt9uNAYcmc1VR/yXxE=";
          };
        });
      })
    ];
    config.allowUnfree = true;
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;

        trusted-users = [
          "root"
          "amantha"
        ];

        substituters = [
          "https://devenv.cachix.org"
          "https://alexymantha.cachix.org"
        ];

        trusted-public-keys = [
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "alexymantha.cachix.org-1:yUrFTN9X9HjjMhMrHSV+iDY0r+ZRdVUPisI6Io4PrOc="
        ];
      };

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.supportedFilesystems = [ "cifs" ];

  boot = {
    plymouth = {
      enable = true;
      theme = "spinner_alt";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "spinner_alt" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

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
    hostName = "amantha-nixos";
    networkmanager.enable = false; # Easiest to use and most distros use this by default.
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users.amantha = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBBuACml/oi+pUzaNFQeOW+8+wWegqljXARwKFpGwnjHj3Q/YIraseXnVsSyEZ8VMR2OGyVA2pAFIIs54j5kHSWzOKbQBEF2PdEob/n6igHaLu2Df88KNar7s1HbZD6wStg== Public key for PIV Authentication" # Yubikey 5c nano
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBPdrGKtUJmJrp9Qbb17e79Vxh0Rq2DneIr2mB23KDpfZobVaa5xazVz7fD82c1egczAcVKl8BD3ap0AiHcKG+o9AXFTmQVWnv5neH5rNUVRB0PdKVRPS6p+9gj1Svyvskg== Public key for PIV Authentication" # Yubikey 5c nfc
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.cachix
    pkgs.fzf
    pkgs.git
    pkgs.gnumake
    pkgs.python3
    pkgs.unzip
    pkgs.usbutils
    pkgs.jq
    pkgs.yq
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.brightnessctl
    pkgs.zellij-switch
    pkgs.xdg-user-dirs
    pkgs.sbctl
  ];

  services.netbird.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.seatd.enable = true;
  security.polkit.enable = true;

  hardware.graphics.enable = true;
  hardware.keyboard.qmk.enable = true;
  hardware.bluetooth.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  fileSystems."/mnt/alexy" = {
    device = "//10.0.0.250/alexy";
    fsType = "cifs";
    options = [
      "credentials=/etc/smb-credentials-alexy"
      "uid=1000"
      "gid=100"
      "vers=3.1.1"
      "_netdev"
      "nofail"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
