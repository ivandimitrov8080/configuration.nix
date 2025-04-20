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
  flake = x: optionalString (hasAttr "flake" x) "--flake ${x.flake}";
  profile = x: optionalString (hasAttr "profile" x) "--profile-name ${x.profile}";
  targetHost = x: optionalString (hasAttr "targetHost" x) "--target-host ${x.targetHost}";
  useRemoteSudo =
    x: optionalString (hasAttr "useRemoteSudo" x && x.useRemoteSudo) "--use-remote-sudo";
  command =
    x:
    # nu
    ''
      def --wrapped "main ${x.name}" [...rest] {
        ${x.command} ${x.subcommand} ${flake x} ${profile x} ${targetHost x} ${useRemoteSudo x} ...$rest
      }'';
in
writers.writeNuBin "xin" ''
  ${concatStringsSep "\n" (map (x: command x) hosts)}
  ${(readFile ./main.nu)}
''
