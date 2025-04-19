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
          nova-iso = inputs.nixos-generators.nixosGenerate {
            inherit system;
            format = "install-iso";
            modules = [
              top.config.flake.nixosModules.flakeModule
              top.config.flake.nixosModules.default
              top.config.flake.nixosModules.rest
              {
                media.enable = true;
                hotspots.enable = true;
              }
            ];
          };
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
                targetHost = "vpsfree-root";
                flake = "/home/ivand/src/configuration.nix/#vps";
              }
              {
                name = "stara";
                sudo = false;
                command = "nixos-rebuild";
                subcommand = "switch";
                targetHost = "stara-root";
                flake = "/home/ivand/src/configuration.nix/#stara";
              }
            ];
          };
          default = xin;
        };
    };
}
