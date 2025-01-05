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
  };
}
