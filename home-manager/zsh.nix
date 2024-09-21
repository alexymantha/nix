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
        source ~/.zshrc.post
      '';
    };
}
