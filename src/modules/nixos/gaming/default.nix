{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "enable gaming config";
  };
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (import ./unfree.nix);
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        "amdgpu.runpm=0"
      ];
    };
    hardware = {
      graphics.enable = true;
      amdgpu = {
        initrd.enable = true;
        amdvlk.enable = true;
      };
    };
    programs.steam = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      xonotic
      steamcmd
      radeontop
      discord
      (pkgs.makeDesktopItem {
        name = "dota";
        desktopName = "DotA 2";
        exec = "${pkgs.steam}/bin/steam steam://rungameid/570";
        terminal = false;
        icon = ./dota2.png;
      })
      (pkgs.makeDesktopItem {
        name = "cs2";
        desktopName = "Counter Strike 2";
        exec = "${pkgs.steam}/bin/steam steam://rungameid/730";
        terminal = false;
        icon = ./cs2.png;
      })
    ];
    systemd.network.networks.wg0 = {
      routingPolicyRules = import ./steam-route-rules.nix;
    };
    home-manager.users.ivand = {
      wayland.windowManager.sway = {
        config = {
          startup = [
            { command = "exec steam'"; }
          ];
          assigns = {
            "3" = [
              { class = "^dota2$"; }
              { class = "^cs2$"; }
            ];
            "9" = [ { class = "^steam$"; } ];
          };
        };
      };
    };
  };
}
