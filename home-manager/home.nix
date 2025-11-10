{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./git.nix
    ./neovim.nix
    ./fish.nix
    ./zellij.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.rust-overlay.overlays.default
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cloudflare-warp"
        "obsidian"
        "spotify"
        "vault"
        "slack"
      ];
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    ghostty = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs.ghostty;
      settings = {
        theme = "catppuccin-macchiato";
        font-size = 18;
        keybind = [
          "cmd+t=unbind"
          "cmd+n=unbind"
          "cmd+c=unbind"
          "cmd+w=unbind"
          "cmd+opt+left=unbind"
          "cmd+opt+right=unbind"
        ];
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    # Dev tools
    rustc
    cargo
    coreutils
    devenv
    gcc
    unstable.go
    unstable.nodejs_22
    zig
    zls
    # Utils
    fd
    bat
    ripgrep
    eza
    delta
    zoxide
    fzf
    yq-go
    rsync
    yubico-piv-tool
    nixos-anywhere
    # Apps
    obsidian
    spotify
    slack
    brave
    # Networking
    dnsutils
    openssl
    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
  ];

  home.sessionVariables = {
    YUBICO_PATH = "${pkgs.yubico-piv-tool}/lib";
  };

  home.file.".config/Yubico/u2f_keys".text = ''
    amantha:BoQ5kI6GuB5JPTi678Jp37AgtxstZq4jTzKHbFvYzDNH+R3IqchopN0ItO0bVbxQItaxD0p7vl7n0Op0fWjGrw==,kHhDd0dvFTpum6cTw/k/mDf5lWj8+aoz+YAKBqADGZsuYSDs6zvVRONGP2egM8b35wULUOzQvUTCMLr4pOeafQ==,es256,+presence
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
