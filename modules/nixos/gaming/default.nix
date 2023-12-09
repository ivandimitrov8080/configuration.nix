{ nixpkgs, ... }:
{
  imports = [ ../nvidia ];
  # Uses unfree shit
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "steam"
      "steamcmd"
      "steam-original"
      "steam-run"
      "nvidia-settings"
      "nvidia-x11"
      "nvidia-persistenced"
    ];
  programs.steam = {
    enable = true;
  };
}

