{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.bash;
  users.mutableUsers = false;
}
