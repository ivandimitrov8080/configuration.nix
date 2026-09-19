{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  pango,
  lib,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "ndlm";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "ivandimitrov8080";
    repo = "ndlm";
    rev = "1b2175f385f5cad6c82863abb103546463df2d0d";
    hash = "sha256-c1ztv4qrMzdaG84CxQ2BeEnZJi2B8TYdBQC/l2dTb4A=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    cairo
    pango.dev
  ];
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };
  cargoHash = null;
  meta = {
    description = "Not (so) dummy login manager";
    homepage = "https://github.com/ivandimitrov8080/ndlm";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
