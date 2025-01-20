_: {
  services = {
    dbus.enable = true;
    logind = {
      killUserProcesses = true;
      powerKeyLongPress = "reboot";
    };
  };
}
