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
    rev = "799f976aa9f2ba479eddd763b700ceb4e8a249d1";
    hash = "sha256-3eZQHHBZnWNZWVS2FobjbwXz4T4l/QzUi9zRmuOivak=";
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
