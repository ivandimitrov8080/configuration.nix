{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
  nix
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
    ];
    extraLuaConfig = ''
      addServers({
          nixd = {}
      })
    '';
  };
}
