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
    ./zsh.nix
    ./neovim.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nur.overlay
    ];
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "spotify"
        "cloudflare-warp"
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
          enable_wayland = false;
          font = wezterm.font("JetBrains Mono"),
          font_size = 24.0,
          color_scheme = "Catppuccin Macchiato",
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
    cargo
    chezmoi
    coreutils
    kitty
    devenv
    dnsutils
    fd
    fzf
    unstable.go
    ginkgo # Use direnv for projects that need it?
    unstable.nodejs_22
    yubico-piv-tool
    ripgrep
    spotify
    # K8s stuff
    kubectl
    kubernetes-helm
    # Java stuff
    temurin-bin-20
    jdt-language-server
  ];

  home.sessionVariables = {
    YUBICO_PATH = "${pkgs.yubico-piv-tool}/lib";
    JDTLS_PATH = "${pkgs.jdt-language-server}/share";
  };

  home.file.".config/Yubico/u2f_keys".text = ''
    amantha:BoQ5kI6GuB5JPTi678Jp37AgtxstZq4jTzKHbFvYzDNH+R3IqchopN0ItO0bVbxQItaxD0p7vl7n0Op0fWjGrw==,kHhDd0dvFTpum6cTw/k/mDf5lWj8+aoz+YAKBqADGZsuYSDs6zvVRONGP2egM8b35wULUOzQvUTCMLr4pOeafQ==,es256,+presence
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
