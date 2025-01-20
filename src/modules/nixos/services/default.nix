{
  services = {
    dbus.enable = true;
    logind = {
      killUserProcesses = true;
      powerKeyLongPress = "reboot";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
