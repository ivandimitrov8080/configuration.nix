{
  pkgs,
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
  options.jetbrains.idea = {
    enable = mkEnableOption "enable intellij idea config";
  };

  config = mkIf cfg.enable {
    programs.java.enable = true;
    programs.java.package = pkgs.jdk;
    environment = {
      systemPackages = with pkgs; [
        jetbrains.idea-community
        maven
      ];
    };
  };
}
