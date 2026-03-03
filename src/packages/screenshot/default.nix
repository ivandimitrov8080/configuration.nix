{
  writers,
  sway-contrib,
  xdg-user-dirs,
  lib,
  ...
}:
writers.writeNuBin "screenshot" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      sway-contrib.grimshot
      xdg-user-dirs
    ]}"
  ];
} (builtins.readFile ./screenshot.nu)
