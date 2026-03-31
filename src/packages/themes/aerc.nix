{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation {
  name = "catppuccin-aerc";
  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "aerc";
    rev = "3580c723ee071e512d5e41bf88cea837b4f23746";
    hash = "sha256-jYFk8eZ3um5S7DxiGbGHGa05/HkxYYrqUX8cEhNEEu0=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out
    cp dist/* $out
  '';
}
