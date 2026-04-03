{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation {
  name = "english-words";
  src = fetchFromGitHub {
    owner = "dwyl";
    repo = "english-words";
    rev = "20f5cc9b3f0ccc8ce45d814c532b7c2031bba31c";
    hash = "sha256-PfBQ9iavOLx7M8+j0TXASUxVamPiQn2YXsiuUmz4XCg=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    mkdir -p $out
    cp ./words_alpha.txt $out
  '';
}
