{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  haskell
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      haskell-language-server
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          hls = {}
      })
    '';
  };
}
