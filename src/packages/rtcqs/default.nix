{ pkgs, fetchPypi, ... }:

pkgs.python3.pkgs.buildPythonApplication rec {
  pname = "rtcqs";
  version = "0.6.6";
  format = "pyproject";

  # Dont check that the gui portion of the rtcqs package (rtcqs_gui) can be
  # run. It uses PySimpleGUI, which, though it is available in nixpkgs,
  # doesn't work properly.  It is a deliberately obfuscated commercial
  # library, and isn't readily fixable.  rtcqs_gui offers no functionality
  # that isn't offered by the command-line utility rtcqs.
  #
  # The runtime dependency check would otherwise discover PySimpleGUI and fail
  # the build. Disable it instead of replacing the hook with the `true` binary.
  pythonRuntimeDepsCheck = false;

  buildInputs = [ pkgs.python3.pkgs.setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KocBblCTx74MuBKbn1Y0zIcxhiFTHNtFZa4qeVfexnE=";
  };
}
