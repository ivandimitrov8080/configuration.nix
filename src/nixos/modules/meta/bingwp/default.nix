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
    enable = mkEnableOption "enable swayland config";
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
            OnCalendar = "*-*-* 10:00:00";
            Persistent = true;
          };
        };
      };
      services = {
        bingwp = {
          description = "Download bing image of the day";
          script = ''
            ${pkgs.nushell}/bin/nu -c "http get ('https://bing.com' + ((http get https://www.bing.com/HPImageArchive.aspx?format=js&n=1).images.0.url)) | save  ('/var/pic' | path join ( [ (date now | format date '%Y-%m-%d'), '.jpeg' ] | str join ))"
            ${pkgs.nushell}/bin/nu -c "${pkgs.toybox}/bin/ln -sf (ls /var/pic | where type == file | get name | sort | last) /var/pic/latest.jpeg"
          '';
        };
      };
    };
  };
}
