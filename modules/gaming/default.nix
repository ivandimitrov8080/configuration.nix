{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "nvidia-persistenced"
      "steam"
      "steamcmd"
      "steam-original"
      "steam-run"
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

  programs.steam = {
    enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      steamcmd
      steam-tui
    ];
  };
}

