{
  stdenv,
  fetchFromGitea,
  makeWrapper,
  lib,
  zip,
  file,
  uutils-coreutils-noprefix,
}:
stdenv.mkDerivation rec {
  pname = "walogram";
  version = "1.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "thirtysix";
    repo = "walogram";
    tag = "v${version}";
    hash = "sha256-3vRuzTnqHsuLV/7L61qM8GzJgJoBC5vwCoc+M/45bHM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall
    export PREFIX=$out
    make install
    runHook postInstall
  '';

  postInstall = ''
    sed -i '/^constants=/s|.*|constants='"'$out/share/walogram/constants.tdesktop-theme'"'|' $out/bin/${pname}
    patchShebangs $out/bin/${pname}
    wrapProgram $out/bin/${pname} \
        --prefix PATH : ${
          lib.makeBinPath [
            zip
            file
            uutils-coreutils-noprefix
          ]
        }
  '';

}
