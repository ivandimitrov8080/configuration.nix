{ pkgs, lib, ... }:
{
  programs.neovim = {
    extraLuaConfig = lib.fileContents ./nvim/util.lua;
  };
}
