{ pkgs, config, ... }:
let
  shells = with pkgs; [
    bash
    zsh
    nushell
  ];
  shellAliases = {
    sc = "systemctl";
    flip = "shuf -r -n 1 -e Heads Tails";
  }
  // (
    if config.programs.zoxide.enable then
      {
        cd = "z";
        cdi = "zi";
      }
    else
      { }
  )
  // (
    if builtins.elem pkgs.eza config.environment.systemPackages then
      {
        eza = "eza --long --header --icons --smart-group --mounts --group-directories-first --octal-permissions --git";
        ls = "eza";
        la = "eza --all -a";
        lt = "eza --git-ignore --all --tree --level=10";
      }
    else
      { }
  );
in
{
  environment.systemPackages = shells;
  environment.shells = shells;
  environment.shellAliases = shellAliases;
}
