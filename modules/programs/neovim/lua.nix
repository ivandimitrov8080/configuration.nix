{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  lua
  luadoc
  luau
  luap
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      lua
      lua-language-server
      stylua
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          lua_ls = {}
      })
    '';
  };
}
