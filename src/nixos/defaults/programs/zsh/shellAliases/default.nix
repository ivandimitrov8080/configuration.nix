{ lib, config, ... }:
{
  programs.zsh.shellAliases = {
    cal = "cal $(date +%Y)";
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
  );
}
