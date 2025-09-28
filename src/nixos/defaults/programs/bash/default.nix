{ lib, config, ... }:
let
  cfg = config.programs.bash;
in
{
  programs.bash.interactiveShellInit = ''
    ${lib.optionalString cfg.blesh.enable "set -o vi"}
  '';
  programs.bash.blesh.enable = true;
}
