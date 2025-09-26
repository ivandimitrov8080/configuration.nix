{
  writeShellApplication,
  sway-contrib,
  xdg-user-dirs,
  uutils-coreutils-noprefix,
  ...
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [
    sway-contrib.grimshot
    xdg-user-dirs
    uutils-coreutils-noprefix
  ];
  text = builtins.readFile ./main.sh;
}
