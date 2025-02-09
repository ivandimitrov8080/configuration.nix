{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "rofi-themes-collection";
  src = pkgs.fetchFromGitHub {
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "c8239a45edced3502894e1716a8b661fdea8f1c9";
    hash = "sha256-1F+qMwchTUWdEWpsIqyVG5pYmqdvmsCckvSmg7pYjdY=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out
    cp themes/* $out
  '';
}
