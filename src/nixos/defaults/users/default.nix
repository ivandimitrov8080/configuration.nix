{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;
  users.extraGroups.mlocate = { };
}
