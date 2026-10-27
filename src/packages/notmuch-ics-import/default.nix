{ writers, haskellPackages, ... }:
writers.writeHaskellBin "notmuch-ics-import" {
  libraries = with haskellPackages; [
    notmuch
    mime
  ];
} (builtins.readFile ./Main.hs)
