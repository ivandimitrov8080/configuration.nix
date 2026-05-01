{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    ;
  inherit (lib.types) str;
  cfg = config.meta.bingwp;
in
{
  options.meta.bingwp = {
    enable = mkEnableOption "enable bingwp config";
    downloadDir = mkOption {
      type = str;
      default = "/var/pic";
    };
  };
  config = mkIf cfg.enable {
    system.activationScripts = {
      bingwp.text = ''
        mkdir -p ${cfg.downloadDir}
      '';
    };
    systemd = {
      timers = {
        bingwp = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 13:00:00";
            Persistent = true;
          };
        };
      };
      services = {
        bingwp =
          let
            outDir = "/var/pic";
            exec =
              pkgs.writers.writeNuBin "exec"
                {
                  makeWrapperArgs = [
                    "--prefix"
                    "PATH"
                    ":"
                    "${lib.makeBinPath [ pkgs.toybox ]}"
                  ];
                }
                # nu
                ''
                  let file = (http get --raw $"https://bing.com((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)")
                  let fname = $"${outDir}/(date now | format date '%Y-%m-%d').jpeg"
                  $file | save --raw $fname
                  ln -sf $fname ${outDir}/latest.jpeg
                '';
          in
          {
            description = "Download bing image of the day";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig = {
              Type = "oneshot";
              ReadWritePaths = [ outDir ];
              ExecStart = "${exec}/bin/exec";
            };
          };
      };
    };
  };
}
