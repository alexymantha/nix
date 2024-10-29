{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./neovim.nix
    ./zsh.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.nur.overlay
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cloudflare-warp"
        "obsidian"
        "spotify"
      ];
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          color_scheme = "Catppuccin Macchiato",
          enable_wayland = false;
          font = wezterm.font("JetBrains Mono"),
          font_size = 24.0,
          hide_tab_bar_if_only_one_tab = true,
        }
      '';
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
    cargo
    coreutils
    devenv
    unstable.go
    unstable.nodejs_22
    zig
    # Utils
    fd
    fzf
    ripgrep
    yubico-piv-tool
    # Apps
    obsidian
    spotify
    # Networking
    dnsutils
    # Kubernetes
    kubectl
    kubernetes-helm
    # Java
    temurin-bin-20
    jdt-language-server
  ];

  home.sessionVariables = {
    JDTLS_PATH = "${pkgs.jdt-language-server}/share";
    YUBICO_PATH = "${pkgs.yubico-piv-tool}/lib";
  };

  home.file.".config/Yubico/u2f_keys".text = ''
    amantha:BoQ5kI6GuB5JPTi678Jp37AgtxstZq4jTzKHbFvYzDNH+R3IqchopN0ItO0bVbxQItaxD0p7vl7n0Op0fWjGrw==,kHhDd0dvFTpum6cTw/k/mDf5lWj8+aoz+YAKBqADGZsuYSDs6zvVRONGP2egM8b35wULUOzQvUTCMLr4pOeafQ==,es256,+presence
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
