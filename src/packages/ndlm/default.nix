{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  pango,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "ndlm";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "ivandimitrov8080";
    repo = "ndlm";
    rev = "1c2b9bc4b9ec15ebd4f50d75c1f51a281fbcaef5";
    hash = "sha256-ty6Q2epYQSOmuSPMvF0dp6M9rfsnNmEWPiaLrzfFBIA=";
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
}
