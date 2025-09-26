{
  writers,
  lib,
  wireplumber,
  ...
}:
let
  inherit (builtins) readFile;
in
writers.writeNuBin "volume"
  {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath [ wireplumber ]}"
    ];
  }
  ''
    ${(readFile ./main.nu)}
  ''
