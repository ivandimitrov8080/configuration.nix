{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "mutt-themes";
  src = pkgs.fetchFromGitHub {
    owner = "altercation";
    repo = "mutt-colors-solarized";
    rev = "3b23c55eb43849975656dd89e3f35dacd2b93e69";
    hash = "sha256-UWQ4M3/4PsZzt3UZguy10WufXDOp7IKABzgVjkGNJNQ=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out
    cp ./*.muttrc $out
  '';
}
