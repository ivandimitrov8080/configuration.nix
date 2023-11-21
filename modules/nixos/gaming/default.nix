{ nixpkgs, ... }:
{
  # Uses unfree shit
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "steam"
      "steamcmd"
      "steam-original"
      "steam-run"
    ];
  programs.steam = {
    enable = true;
  };
}

