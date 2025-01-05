{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.music;
in
{
  options.music = {
    enable = mkEnableOption "music";
  };
  config = mkIf cfg.music.enable {
    imports = [ inputs.musnix.nixosModules.musnix ];
    services.pipewire = {
      jack.enable = mkDefault true;
      extraConfig = {
        jack."69-low-latency" = {
          "jack.properties" = {
            "node.latency" = mkDefault "64/48000";
          };
        };
      };
    };
    musnix = {
      enable = mkDefault true;
      rtcqs.enable = mkDefault true;
      kernel = {
        realtime = mkDefault true;
        packages = mkDefault pkgs.linuxPackages-rt_latest;
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
