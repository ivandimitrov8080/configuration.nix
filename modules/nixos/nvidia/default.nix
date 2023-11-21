{ nixpkgs, ... }:
{
  # Uses unfree shit
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "nvidia-persistenced"
    ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
    modesetting.enable = true;
    nvidiaSettings = true;
  };
}

