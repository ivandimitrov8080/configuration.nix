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
    realtime = mkEnableOption "enable realtime kernel";
  };
  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        ardour
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
    (mkIf cfg.realtime {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelPatches = [
        {
          name = "realtime-config";
          patch = null;
          extraStructuredConfig = with lib.kernel; {
            PREEMPT = lib.mkForce yes;
            PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
            PREEMPT_RT = yes;
            # Fix error: unused option: PREEMPT_RT.
            EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt)
            # Fix error: unused option: RT_GROUP_SCHED.
            RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
          };
        }
      ];
    })
  ];
}
