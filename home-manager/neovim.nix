{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs
      gopls
      gotools
      helm-ls
      lua-language-server
      pyright
      rust-analyzer
      terraform-ls
      typescript
      # Needed for the JSON ls
      vscode-langservers-extracted
      yaml-language-server
      zls
      nodePackages.typescript-language-server
    ];
  };

  home.file.".config/nvim" = {
    source = ./configs/nvim;
    recursive = true;
  };
}
