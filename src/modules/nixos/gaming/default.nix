{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "enable gaming config";
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "steamcmd"
        "discord"
      ];
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        "amdgpu.runpm=0"
      ];
    };
    hardware = {
      graphics.enable = true;
      amdgpu = {
        initrd.enable = true;
        amdvlk.enable = true;
      };
    };
    programs.steam = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      xonotic
      steamcmd
      radeontop
      discord
    ];
    systemd.network.networks.wg0 = {
      routingPolicyRules = import ./steam-route-rules.nix;
    };
  };
}
