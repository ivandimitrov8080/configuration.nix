{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    extraPackages = with pkgs; [
      alejandra
      black
      go
      gopls
      libclang
      lua
      lua-language-server
      nodePackages_latest.prettier
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
      nodePackages_latest."@tailwindcss/language-server"
      nodePackages_latest."@prisma/language-server"
      python311Packages.python-lsp-black
      python311Packages.python-lsp-server
      ripgrep
      rnix-lsp
      stylua
      haskell-language-server
      ghc
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
