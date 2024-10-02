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
    defaultEditor = true;
  };

  # All packages needed by neovim
  # Mostly LSPs and debug tooling
  home.packages = with pkgs; [
    gopls
    gotools
    typescript
    pyright
    lua-language-server
    rust-analyzer
    yaml-language-server
    # Needed for the JSON ls
    vscode-langservers-extracted
    terraform-ls
    dockerfile-language-server-nodejs
    helm-ls
  ];

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
