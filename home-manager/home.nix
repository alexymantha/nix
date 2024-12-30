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
        "vault"
        "jetbrains.idea-community-bin"
      ];
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-macchiato";
        default_mode = "locked";
        default_layout = "compact";
        ui = {
          pane_frames = {
            hide_session_name = true;
          };
        };
      };
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
    yq
    obsidian
    unstable.go
    ginkgo # Use direnv for projects that need it?
    unstable.nodejs_22
    yubico-piv-tool
    ripgrep
    rsync
    yubico-piv-tool
    nixos-anywhere
    # Apps
    obsidian
    spotify
    # Networking
    dnsutils
    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
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
