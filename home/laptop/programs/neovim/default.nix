{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    extraPackages = with pkgs; [
      # nix
      rnix-lsp
      alejandra
      #	go
      go
      gopls
      # c/c++
      libclang
      # lua
      lua
      lua-language-server
      stylua
      # js/ts
      nodePackages_latest.prettier
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
      nodePackages_latest."@tailwindcss/language-server"
      nodePackages_latest."@prisma/language-server"
      # bash
      nodePackages_latest.bash-language-server
      shfmt
      shellcheck
      # python
      python311Packages.python-lsp-black
      python311Packages.python-lsp-server
      black
      # haskell
      ghc
      haskell-language-server
      # neovim
      ripgrep
      # html
      nodePackages_latest.vscode-html-languageserver-bin
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-surround
      nvim-ts-autotag
      vim-prisma
      autoclose-nvim
      barbar-nvim
      cmp-nvim-lsp
      comment-nvim
      gitsigns-nvim
      luasnip
      nightfox-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      plenary-nvim
      telescope-nvim
      telescope-nvim
      toggleterm-nvim
      vim-vinegar
    ];
    extraLuaConfig = lib.fileContents ./nvim/init.lua;
  };
}
