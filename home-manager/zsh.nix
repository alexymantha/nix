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
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
    };
    initExtraFirst = ''
      # Autostart zellij
      eval "$(zellij setup --generate-auto-start zsh)"

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
      source $HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

      source $HOME/.zsh/lib/fzf-history.zsh
      source $HOME/.zsh/lib/keybinds.zsh
      source $HOME/.zsh/lib/clipboard.zsh
    '';
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      dev = "cd \"$HOME/dev/$(ls \"$HOME/dev\" | fzf)\"";
      k = "kubectl";
      kcx = "kubectx && zellij pipe 'zjstatus::rerun::command_kubectx'";
      kns = "kubens && zellij pipe 'zjstatus::rerun::command_kubens'";
    };
  };
  home.file.".zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/refs/heads/main/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh";
    sha256 = "038hf207y90gcj7q8j8mn27fhhhniivgpfbcvlydvj7knkhw08ld";
  };

  home.file.".zsh/lib" = {
    source = ./configs/zsh/lib;
    recursive = true;
  };
}
