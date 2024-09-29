{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
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
      source "$HOME/.zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      source ~/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Autostart zellij
      eval "$(zellij setup --generate-auto-start zsh)"
    '';
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      # Kubernetes stuff;
      k = "kubectl";
      kns = "kubens";
      kcx = "kubectx";
      dev = "cd \"$HOME/dev/$(ls \"$HOME/dev\" | fzf)\"";
    };
  };
  # home.file.".zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh".source = builtins.fetchurl {
  #   url = "https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/refs/heads/main/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh";
  #   sha256 = "038hf207y90gcj7q8j8mn27fhhhniivgpfbcvlydvj7knkhw08ld";
  # };
}
