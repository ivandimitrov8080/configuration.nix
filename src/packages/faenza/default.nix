{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "faenza";
  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-delft";
    rev = "dd693fcf7cbd2d9fb689fada278a58f4b3e43a75";
    hash = "sha256-fluSh2TR1CdIW54wkUp1QRB0m9akFKnSn4d+0z6gkLA=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./* $out
    runHook postInstall
  '';
}
