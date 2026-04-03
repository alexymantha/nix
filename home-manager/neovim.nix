{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.dockerfile-language-server
      pkgs.gopls
      pkgs.gotools
      pkgs.helm-ls
      pkgs.lua-language-server
      pkgs.pyright
      pkgs.rust-analyzer
      pkgs.terraform-ls
      pkgs.typescript
      # Needed for the JSON ls
      pkgs.vscode-langservers-extracted
      pkgs.yaml-language-server
      pkgs.typescript-language-server
      pkgs.unstable.harper # Spellcheck
      pkgs.htmx-lsp
      pkgs.tailwindcss-language-server
      pkgs.nil # Nix language server
      pkgs.buf # Protobuf language server
    ];
  };

  home.file.".config/nvim" = {
    source = ./configs/nvim;
    recursive = true;
  };
}
