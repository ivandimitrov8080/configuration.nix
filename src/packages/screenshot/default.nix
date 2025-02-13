{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [ sway-contrib.grimshot ];
  text = builtins.readFile ./main.sh;
}
