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
      ];
  };

  programs = {
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      defaultEditor = true;
    };
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

  programs.waybar.enable = true;
  # From https://github.com/catppuccin/fuzzel/blob/main/themes/macchiato/red.ini
  home.file.".config/fuzzel/themes/macchiato/red.ini".text = ''
    [colors]
    background=24273add
    text=cad3f5ff
    match=ed8796ff
    selection=5b6078ff
    selection-match=ed8796ff
    selection-text=cad3f5ff
    border=b7bdf8ff
  '';
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = "${config.xdg.configHome}/fuzzel/themes/macchiato/red.ini";
        dpi-aware = true;
        font = "JetBrainsMono Nerd Font:size=24";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv = true;
    silent = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    cargo
    chezmoi
    coreutils
    kitty
    devenv
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
