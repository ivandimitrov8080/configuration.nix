{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meta.gaming;
in
{
  options.meta.gaming = {
    enable = mkEnableOption "enable gaming config";
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (import ./unfree.nix);
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        "amdgpu.runpm=0"
      ];
    };
    hardware = {
      graphics.enable = true;
      amdgpu.initrd.enable = true;
    };
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
        extraPackages = with pkgs; [ gamescope ];
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
      };
    };
    environment.systemPackages = with pkgs; [ umu-launcher ] ++ desktopItems;
    systemd = {
      network.networks.wg0 = {
        routingPolicyRules = import ./steam-route-rules.nix;
      };
      settings.Manager = {
        DefaultTimeoutStopSec = "5s";
      };
    };
  };
}
