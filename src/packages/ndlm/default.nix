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
    rev = "31cc3cb95a89b6bb18c09a82fea724f04544655c";
    hash = "sha256-MjjF+sS1A3yEQAw3rsW7jYHkPHrZewZCp4XqZ6AH5jA=";
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
