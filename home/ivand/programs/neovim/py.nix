{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  python
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      python311Packages.python-lsp-server
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          pylsp = {},
      })
    '';
  };
}
