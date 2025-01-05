{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "gaming";
  };
  config = mkIf cfg.gaming.enable {
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        amdvlk.enable = true;
      };
    };
    programs.steam = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      xonotic
      steamcmd
    ];
  };
}
