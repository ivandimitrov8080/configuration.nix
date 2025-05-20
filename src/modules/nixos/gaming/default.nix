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
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
      };
    };
    environment.systemPackages = with pkgs; [
      airshipper
      discord
      minetest
      radeontop
      steamcmd
      umu-launcher
      xonotic
      (pkgs.makeDesktopItem {
        name = "dota";
        desktopName = "DotA 2";
        exec = "${pkgs.steam}/bin/steam steam://rungameid/570";
        terminal = false;
        icon = "${pkgs.faenza}/Delft/apps/96/dota2.svg";
      })
      (pkgs.makeDesktopItem {
        name = "cs2";
        desktopName = "Counter Strike 2";
        exec = "${pkgs.steam}/bin/steam steam://rungameid/730";
        terminal = false;
        icon = "${pkgs.faenza}/Delft/apps/96/csgo.svg";
      })
      (pkgs.makeDesktopItem {
        name = "valheim";
        desktopName = "Valheim";
        exec = "${pkgs.steam}/bin/steam steam://rungameid/892970";
        terminal = false;
        icon = ./valheim.jpg;
      })
    ];
    systemd = {
      network.networks.wg0 = {
        routingPolicyRules = import ./steam-route-rules.nix;
      };
      extraConfig = ''
        DefaultTimeoutStopSec=5s
      '';
    };
    home-manager.users.ivand = {
      wayland.windowManager.sway = {
        config = {
          input = {
            "type:touchpad" = {
              events = "disabled";
            };
          };
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
