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
    rev = "3cb54156777d875ee55bfc234295c15f256790d9";
    hash = "sha256-EjtYr6YzvJKverRFfvQy+7lL73GUGzN30VR0hOtla3g=";
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
