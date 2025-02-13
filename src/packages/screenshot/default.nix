{ writeShellApplication, sway-contrib, ... }:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [ sway-contrib.grimshot ];
  text = builtins.readFile ./main.sh;
}
