{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    literalExpression
    mkIf
    mkOrder
    ;
  cfg = config.programs.zoxide;
  cfgOptions = lib.concatStringsSep " " cfg.options;
in
{
  meta.maintainers = [ ];

  options.programs.zoxide = {
    enable = mkEnableOption "zoxide";

    package = mkOption {
      type = types.package;
      default = pkgs.zoxide;
      defaultText = literalExpression "pkgs.zoxide";
      description = ''
        Zoxide package to install.
      '';
    };

    options = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--no-cmd" ];
      description = ''
        List of options to pass to zoxide init.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveShellInit = (
      mkOrder 2000 ''
        eval "$(${cfg.package}/bin/zoxide init bash ${cfgOptions})"
      ''
    );

    programs.zsh.interactiveShellInit = (
      mkOrder 2000 ''
        eval "$(${cfg.package}/bin/zoxide init zsh ${cfgOptions})"
      ''
    );

    programs.fish.interactiveShellInit = ''
      ${cfg.package}/bin/zoxide init fish ${cfgOptions} | source
    '';
  };
}
