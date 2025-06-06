_final: prev:
let
  inherit (prev) callPackage;
in
{
  # nvim = callPackage ./nvim {
  #   inherit (inputs.nixvim.legacyPackages.${system}) makeNixvim;
  #   package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  # };
  screenshot = callPackage ./screenshot { };
  themes-rofi = callPackage ./themes/rofi.nix { };
  themes-mutt = callPackage ./themes/mutt.nix { };
  themes-gtk = callPackage ./themes/gtk-theme-catppuccin.nix { };
  faenza = callPackage ./faenza { };
  volume = callPackage ./volume { };
  avante-nvim = callPackage ./avante-nvim { };
  rtcqs = callPackage ./rtcqs { };
  walogram = callPackage ./walogram { };
}
