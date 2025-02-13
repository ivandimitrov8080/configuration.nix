{ writeShellApplication, ... }:
writeShellApplication {
  name = "xin";
  text = builtins.readFile ./main.sh;
}
