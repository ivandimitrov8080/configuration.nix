{
  writers,
  lib,
  hosts ? [ ],
  ...
}:
let
  inherit (builtins) readFile;
in
writers.writeNuBin "volume" ''
  ${(readFile ./main.nu)}
''
