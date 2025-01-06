{ lib, ... }:
{
  services = with lib; {
    dbus.enable = mkDefault true;
    logind = {
      killUserProcesses = mkDefault true;
      powerKeyLongPress = mkDefault "reboot";
    };
    pipewire = {
      alsa.enable = mkDefault true;
      pulse.enable = mkDefault true;
    };
    openssh = {
      settings = {
        PermitRootLogin = mkDefault "prohibit-password";
      };
    };
    gitea = {
      appName = mkDefault "src";
      database = {
        type = mkDefault "postgres";
      };
      settings = mkDefault {
        server = {
          DOMAIN = "src.idimitrov.dev";
          ROOT_URL = "https://src.idimitrov.dev/";
          HTTP_PORT = 3001;
        };
        repository = {
          DEFAULT_BRANCH = "master";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
      };
    };
  };
}
