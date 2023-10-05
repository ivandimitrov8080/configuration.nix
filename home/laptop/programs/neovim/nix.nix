{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  nix
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      rnix-lsp
      alejandra
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          rnix = {}
      })
    '';
  };
}
