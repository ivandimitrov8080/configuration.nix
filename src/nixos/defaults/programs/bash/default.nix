{ lib, config, ... }:
let
  cfg = config.programs.bash;
in
{
  programs.bash.shellAliases = config.programs.zsh.shellAliases;
  programs.bash.interactiveShellInit = ''
    ${lib.optionalString cfg.blesh.enable "set -o vi"}
  '';
  programs.bash.blesh.enable = true;
}
