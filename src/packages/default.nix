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
          themes-plymouth = callPackage ./themes/plymouth.nix { };
          xin = pkgs.callPackage ../lib/xin { };
          default = xin;
        };
    };
}
