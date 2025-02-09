{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "plymouth-themes";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "e0f58d6fcf3dbc2d35dfc4fec394217fbfa92666";
    hash = "sha256-He6ER1QNrJCUthFoBBGHBINouW/tozxQy3R79F5tsuo=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -R ./themes/** $out/share/plymouth/themes
  '';
}
