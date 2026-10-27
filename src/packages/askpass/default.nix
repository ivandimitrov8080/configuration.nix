{
  writers,
  lib,
  haskellPackages,
  ...
}:
writers.writeNuBin "askpass" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      haskellPackages.frecently
    ]}"
  ];
} (builtins.readFile ./main.nu)
