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
    environment.systemPackages = with pkgs; [
      umu-launcher
      discord
    ];
    systemd = {
      network.networks.wg0 = {
        routingPolicyRules = import ./steam-route-rules.nix;
      };
      settings.Manager = {
        DefaultTimeoutStopSec = "5s";
      };
      user = {
        timers = {
          steam-desktop-entries = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*-*-* 10:00:00";
              Persistent = true;
            };
          };
        };
        services.steam-desktop-entries =
          let
            exe =
              pkgs.writers.writePython3 "steam-desktop-entries"
                {
                  libraries = with pkgs.python3Packages; [ vdf ];
                }
                # py
                ''
                  import glob
                  import os
                  import vdf
                  steamapps = os.path.expanduser("~/.local/share/Steam/steamapps")


                  def save_desktop_entry(appid, name):
                      appid = str(appid).strip()
                      name = (name or "").strip()
                      path = os.path.expanduser(
                          f"~/.local/share/applications/game-{appid}.desktop"
                      )
                      with open(path, "w", encoding="utf-8") as f:
                          f.write(f"""[Desktop Entry]
                  Exec=steam -silent steam://launch/{appid}/dialog
                  Icon=steam_icon_{appid}
                  Name={name}
                  Terminal=false
                  Type=Application
                  Version=1.5
                  """)


                  for path in sorted(glob.glob(os.path.join(steamapps, "appmanifest_*.acf"))):
                      with open(path, "r", encoding="utf-8", errors="replace") as f:
                          data = vdf.load(f)
                      st = data.get("AppState", {})
                      appid = st.get("appid")
                      name = st.get("name")
                      save_desktop_entry(appid, name)
                '';
          in
          {
            description = "Generate desktop files for all installed games";
            script = ''
              ${exe}
            '';
          };
      };
    };
  };
}
