{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  bash
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      nodePackages_latest.bash-language-server
      shfmt
      shellcheck
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          bashls = {}
      })
    '';
  };
}
