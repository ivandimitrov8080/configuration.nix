_final: prev:
let
  inherit (prev) callPackage;
  hasNixvim = prev ? nixvim;
in
{
  screenshot = callPackage ./screenshot { };
  themes-rofi = callPackage ./themes/rofi.nix { };
  themes-mutt = callPackage ./themes/mutt.nix { };
  themes-gtk = callPackage ./themes/gtk-theme-catppuccin.nix { };
  faenza = callPackage ./faenza { };
  volume = callPackage ./volume { };
  rtcqs = callPackage ./rtcqs { };
  walogram = callPackage ./walogram { };
  ddlm = callPackage ./ddlm { };
  vscode-java-debug = callPackage ./vscode-java-debug { };
  vscode-java-test = callPackage ./vscode-java-test { };
}
// (prev.lib.optionalAttrs hasNixvim {
  nixvim = callPackage ./nixvim { nixvim = prev.nixvim; };
})
