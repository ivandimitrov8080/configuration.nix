{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.music;
in
{
  options.music = {
    enable = mkEnableOption "enable music config";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ guitarix ];
    services.pipewire = {
      jack.enable = true;
      extraConfig = {
        jack."69-low-latency" = {
          "jack.properties" = {
            "node.latency" = "64/48000";
          };
        };
      };
    };
    musnix = {
      enable = true;
      rtcqs.enable = true;
      soundcardPciId = "00:1f.3";
      kernel = {
        realtime = true;
        packages = pkgs.linuxPackages-rt_latest;
      };
    };
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "memlock";
        type = "-";
        value = "1048576";
      }
    ];
  };
}
