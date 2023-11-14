{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  tsx
  jsdoc
  json
  json5
  jsonnet
  http
  html
  astro
  svelte
  prisma
  graphql
  typescript
  javascript
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      nodePackages_latest.prettier
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
      nodePackages_latest."@tailwindcss/language-server"
      nodePackages_latest."@prisma/language-server"
      nodePackages_latest.vscode-html-languageserver-bin
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
      vim-prisma
    ];
    extraLuaConfig = ''
      addServers({
          tsserver = {},
          tailwindcss = {},
          prismals = {},
          html = {
              cmd = { "html-languageserver", "--stdio" }
          },
      })
    '';
  };
}
