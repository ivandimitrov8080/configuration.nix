{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.meta.shells;
in
{
  options.meta.shells = {
    enable = mkEnableOption "enable zsh, xonsh, starship";
  };

  config = mkIf cfg.enable {
    programs = {
      starship.enable = true;
      zsh.enable = true;
      xonsh.enable = true;
      xonsh.extraPackages = ps: with ps; [ requests ];
    };
  };
}
