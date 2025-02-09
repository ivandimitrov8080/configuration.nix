{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "gtk-themes";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "ee8ed32b4f63e9c417249c109818dcc05a2e25da";
    hash = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out
    cp ./themes/* $out
  '';
}
