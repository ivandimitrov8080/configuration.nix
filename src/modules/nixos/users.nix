{ pkgs, lib, ... }:
{
  users.defaultUserShell = lib.mkDefault pkgs.zsh;
}
