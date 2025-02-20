{ inputs, ... }:
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
          xin = pkgs.callPackage ./xin {
            hosts = [
              {
                name = "nova";
                sudo = true;
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "nova";
                flake = "/home/ivand/src/configuration.nix/#nova";
              }
              {
                name = "gaming";
                sudo = true;
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "gaming";
                flake = "/home/ivand/src/configuration.nix/#gaming";
              }
              {
                name = "ai";
                sudo = true;
                command = "nixos-rebuild";
                subcommand = "switch";
                profile = "ai";
                flake = "/home/ivand/src/configuration.nix/#ai";
              }
              {
                name = "vps";
                sudo = false;
                command = "nixos-rebuild";
                subcommand = "switch";
                targetHost = "vpsfree-ivand";
                useRemoteSudo = true;
                flake = "/home/ivand/src/configuration.nix/#vps";
              }
            ];
          };
          default = xin;
        };
    };
}
