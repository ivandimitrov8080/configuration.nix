{
  writers,
  lib,
  hosts ? [ ],
  ...
}:
let
  inherit (builtins)
    map
    concatStringsSep
    readFile
    hasAttr
    ;
  inherit (lib) optionalString;
  sudo = x: optionalString (hasAttr "sudo" x && x.sudo) "sudo";
  flake = x: optionalString (hasAttr "flake" x) "--flake ${x.flake}";
  profile = x: optionalString (hasAttr "profile" x) "--profile-name ${x.profile}";
  targetHost = x: optionalString (hasAttr "targetHost" x) "--target-host ${x.targetHost}";
  useRemoteSudo = x: optionalString (hasAttr "useRemoteSudo" x && x.useRemoteSudo) "--use-remote-sudo";
  command = x: ''
    def "main ${x.name}" [] {
      ${sudo x} ${x.command} ${x.subcommand} ${flake x} ${profile x} ${targetHost x} ${useRemoteSudo x}
    }'';
in
writers.writeNuBin "xin" ''
  ${concatStringsSep "\n" (map (x: command x) hosts)}
  ${(readFile ./main.nu)}
''
