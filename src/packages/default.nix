top@{ inputs, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      config.packages =
        let
          inherit (pkgs) callPackage;
        in
        rec {
          nvim = callPackage ./nvim {
            makeNixvim = inputs.nixvim.legacyPackages.${system}.makeNixvim;
            package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
          };
          screenshot = callPackage ./screenshot { };
          themes-rofi = callPackage ./themes/rofi.nix { };
          themes-mutt = callPackage ./themes/mutt.nix { };
          themes-gtk = callPackage ./themes/gtk-theme-catppuccin.nix { };
          faenza = callPackage ./faenza { };
          volume = callPackage ./volume { };
          avante-nvim = callPackage ./avante-nvim { };
          rtcqs = callPackage ./rtcqs { };
          walogram = callPackage ./walogram { };
          xin = pkgs.callPackage ./xin {
            flakePath = "/home/ivand/src/configuration.nix";
            hosts = [
              {
                name = "nova";
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "nova";
                ref = "nova";
              }
              {
                name = "gaming";
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "gaming";
                ref = "gaming";
              }
              {
                name = "ai";
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "ai";
                ref = "ai";
              }
              {
                name = "music";
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "music";
                ref = "music";
              }
              {
                name = "vps";
                command = "nixos-rebuild";
                subcommand = "switch";
                targetHost = "vpsfree-root";
                ref = "vps";
              }
              {
                name = "stara";
                command = "nixos-rebuild";
                subcommand = "switch";
                targetHost = "stara-root";
                buildHost = "stara-root";
                ref = "stara";
              }
              {
                name = "stara-ai";
                command = "nixos-rebuild";
                subcommand = "switch";
                targetHost = "stara-root";
                buildHost = "stara-root";
                ref = "stara-ai";
              }
            ];
          };
          default = xin;
        };
    };
}
