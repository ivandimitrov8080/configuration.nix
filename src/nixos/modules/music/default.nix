{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    ;
  cfg = config.meta.music;
in
{
  options.meta.music = {
    enable = mkEnableOption "enable music config for realtime audio";
  };
  config = mkMerge [
    (mkIf cfg.enable {
      boot.kernelPackages = pkgs.linuxPackages_zen;
      environment.systemPackages = with pkgs; [
        guitarix
        rtcqs
      ];
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
      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
      ];
    })
  ];
}
