{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meta.ai;
in
{
  options.meta.ai = {
    enable = mkEnableOption "enable ai config";
  };
  config = mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "amdgpu.runpm=0"
      ];
    };
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
    services = {
      ollama = {
        enable = true;
        host = "0.0.0.0";
        acceleration = "rocm";
        rocmOverrideGfx = "11.0.2";
      };
    };
  };
}
