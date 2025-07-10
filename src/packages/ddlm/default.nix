{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "ddlm";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "ivandimitrov8080";
    repo = "ddlm";
    rev = "8a7213909c7a7f4672a6db05ca5fdd0b37c5ceeb";
    hash = "sha256-V3084fBpuCkJ9N0Rw6uBvjQPtZi2BXGxlvmEYH7RahE=";
  };
  cargoHash = "sha256-TcT3dm4ubzij50zPCrgI9YV9UbMdlqL+68ETD8MyhWM=";
}
