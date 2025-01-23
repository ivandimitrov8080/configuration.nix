{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "xin";
  version = "0.0.1";
  src = ./.;
  buildInputs = with pkgs; [
    (ghc.withPackages (hkgs: with hkgs; [ turtle ]))
  ];
  buildPhase = ''
    runHook preBuild
    ghc -O main.hs
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./main $out/bin/xin
    runHook postInstall
  '';
}
